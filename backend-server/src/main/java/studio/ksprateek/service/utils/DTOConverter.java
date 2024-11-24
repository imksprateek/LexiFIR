package studio.ksprateek.service.utils;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import studio.ksprateek.service.dto.*;
import studio.ksprateek.service.entity.*;
import studio.ksprateek.service.models.ERole;
import studio.ksprateek.service.models.Role;
import studio.ksprateek.service.repository.RoleRepository;

import java.util.*;
import java.util.stream.Collectors;

@Component
public class DTOConverter {
    @Autowired
    private RoleRepository roleRepository;

    public UserDTO toUserDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setName(user.getName());
        dto.setEmail(user.getEmail());
        dto.setUsername(user.getUsername());
        dto.setLanguagePreference(user.getLanguagePreference());

        // Map roles to roleNames (Convert ERole to String using name())
        dto.setRoleNames(user.getRoles().stream()
                .map(role -> role.getName().name())  // Correctly convert ERole to String
                .collect(Collectors.toList()));

        return dto;
    }

    public User toUserEntity(UserDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("UserDTO cannot be null");
        }

        User user = User.builder()
                .id(dto.getId())
                .name(dto.getName())
                .email(dto.getEmail())
                .username(dto.getUsername())  // Set username if provided
                .languagePreference(dto.getLanguagePreference())
                .build();

        // If roleNames are present in the DTO, set roles accordingly
        if (dto.getRoleNames() != null && !dto.getRoleNames().isEmpty()) {
            Set<Role> roles = dto.getRoleNames().stream()
                    .map(roleName -> roleRepository.findByName(ERole.valueOf(roleName))  // Convert to ERole enum
                            .orElseThrow(() -> new RuntimeException("Role not found: " + roleName)))
                    .collect(Collectors.toSet());
            user.setRoles(roles);
        }

        return user;
    }




    // Convert FIR Entity to DTO
    public FIRDTO toFIRDTO(FIR fir) {
        FIRDTO dto = new FIRDTO();
        dto.setId(fir.getId());
        dto.setCaseTitle(fir.getCaseTitle());
        dto.setIncidentDescription(fir.getIncidentDescription());
        dto.setIncidentDate(fir.getIncidentDate());
        dto.setLocation(toLocationDTO(fir.getLocation()));
        dto.setRelatedSections(fir.getRelatedSections().stream().map(this::toRelatedSectionDTO).collect(Collectors.toList()));
        dto.setLandmarkJudgments(fir.getLandmarkJudgments().stream().map(this::toLandmarkJudgmentDTO).collect(Collectors.toList()));
        dto.setStatus(fir.getStatus());
        dto.setOfficer(toUserDTO(fir.getOfficerId())); // Map referenced User
        return dto;
    }

    // Convert FIR DTO to Entity
    public FIR toFIREntity(FIRDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("FIRDTO cannot be null");
        }

        // Build the FIR entity using the provided DTO
        FIR fir = FIR.builder()
                .id(dto.getId())
                .caseTitle(dto.getCaseTitle())
                .incidentDescription(dto.getIncidentDescription())
                .incidentDate(dto.getIncidentDate())
                .location(toLocationEntity(dto.getLocation()))
                .relatedSections(dto.getRelatedSections() != null ? dto.getRelatedSections().stream()
                        .map(this::toRelatedSectionEntity)
                        .collect(Collectors.toList()) : new ArrayList<>())
                .landmarkJudgments(dto.getLandmarkJudgments() != null ? dto.getLandmarkJudgments().stream()
                        .map(this::toLandmarkJudgmentEntity)
                        .collect(Collectors.toList()) : new ArrayList<>())
                .status(dto.getStatus())
                .build();

        // Set officerId only if it's present
        if (dto.getOfficer() != null) {
            fir.setOfficerId(toUserEntity(dto.getOfficer()));  // Convert UserDTO to User entity
        }

        return fir;
    }



    // Location Conversion
    private FIRDTO.LocationDTO toLocationDTO(FIR.Location location) {
        if (location == null) return null;
        FIRDTO.LocationDTO dto = new FIRDTO.LocationDTO();
        dto.setLatitude(location.getLatitude());
        dto.setLongitude(location.getLongitude());
        dto.setAddress(location.getAddress());
        return dto;
    }

    private FIR.Location toLocationEntity(FIRDTO.LocationDTO dto) {
        if (dto == null) return null;
        FIR.Location location = new FIR.Location();
        location.setLatitude(dto.getLatitude());
        location.setLongitude(dto.getLongitude());
        location.setAddress(dto.getAddress());
        return location;
    }

    // RelatedSection Conversion
    private FIRDTO.RelatedSectionDTO toRelatedSectionDTO(FIR.RelatedSection section) {
        FIRDTO.RelatedSectionDTO dto = new FIRDTO.RelatedSectionDTO();
        dto.setSectionCode(section.getSectionCode());
        dto.setDescription(section.getDescription());
        dto.setRelevanceScore(section.getRelevanceScore());
        dto.setReasoning(section.getReasoning());
        return dto;
    }

    private FIR.RelatedSection toRelatedSectionEntity(FIRDTO.RelatedSectionDTO dto) {
        FIR.RelatedSection section = new FIR.RelatedSection();
        section.setSectionCode(dto.getSectionCode());
        section.setDescription(dto.getDescription());
        section.setRelevanceScore(dto.getRelevanceScore());
        section.setReasoning(dto.getReasoning());
        return section;
    }

    // LandmarkJudgment Conversion
    private FIRDTO.LandmarkJudgmentDTO toLandmarkJudgmentDTO(FIR.LandmarkJudgment judgment) {
        FIRDTO.LandmarkJudgmentDTO dto = new FIRDTO.LandmarkJudgmentDTO();
        dto.setTitle(judgment.getTitle());
        dto.setSummary(judgment.getSummary());
        dto.setUrl(judgment.getUrl());
        return dto;
    }

    private FIR.LandmarkJudgment toLandmarkJudgmentEntity(FIRDTO.LandmarkJudgmentDTO dto) {
        FIR.LandmarkJudgment judgment = new FIR.LandmarkJudgment();
        judgment.setTitle(dto.getTitle());
        judgment.setSummary(dto.getSummary());
        judgment.setUrl(dto.getUrl());
        return judgment;
    }


    // Convert LegalReference Entity to DTO
    public LegalReferenceDTO toLegalReferenceDTO(LegalReference legalReference) {
        LegalReferenceDTO dto = new LegalReferenceDTO();
        dto.setId(legalReference.getId());
        dto.setType(legalReference.getType());
        dto.setSectionCode(legalReference.getSectionCode());
        dto.setTitle(legalReference.getTitle());
        dto.setDescription(legalReference.getDescription());
        dto.setRelatedJudgments(legalReference.getRelatedJudgments().stream()
                .map(this::toRelatedJudgmentDTO)
                .collect(Collectors.toList()));
        dto.setFirId(legalReference.getFirId() != null ? legalReference.getFirId().getId() : null);
        dto.setCreatedAt(legalReference.getCreatedAt());
        dto.setUpdatedAt(legalReference.getUpdatedAt());
        return dto;
    }

    // Convert LegalReference DTO to Entity
    public LegalReference toLegalReferenceEntity(LegalReferenceDTO dto) {
        return LegalReference.builder()
                .id(dto.getId())
                .type(dto.getType())
                .sectionCode(dto.getSectionCode())
                .title(dto.getTitle())
                .description(dto.getDescription())
                .relatedJudgments(dto.getRelatedJudgments().stream()
                        .map(this::toRelatedJudgmentEntity)
                        .collect(Collectors.toList()))
                .firId(dto.getFirId() != null ? FIR.builder().id(dto.getFirId()).build() : null)
                .build();
    }

    // Convert RelatedJudgment Entity to DTO
    private RelatedJudgementDTO toRelatedJudgmentDTO(RelatedJudgement relatedJudgment) {
        RelatedJudgementDTO dto = new RelatedJudgementDTO();
        dto.setTitle(relatedJudgment.getTitle());
        dto.setSummary(relatedJudgment.getSummary());
        dto.setUrl(relatedJudgment.getUrl());
        return dto;
    }

    // Convert RelatedJudgment DTO to Entity
    private RelatedJudgement toRelatedJudgmentEntity(RelatedJudgementDTO dto) {
        return RelatedJudgement.builder()
                .title(dto.getTitle())
                .summary(dto.getSummary())
                .url(dto.getUrl())
                .build();
    }
}


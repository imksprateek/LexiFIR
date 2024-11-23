package studio.ksprateek.service.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@JsonInclude(JsonInclude.Include.NON_NULL)
public class FIRDTO {
    @Schema(hidden = true)
    private String id;
    private String caseTitle;
    private String incidentDescription;
    private LocalDateTime incidentDate;
    private LocationDTO location;
    private List<RelatedSectionDTO> relatedSections = new ArrayList<>();  // Initialize as empty list
    private List<LandmarkJudgmentDTO> landmarkJudgments = new ArrayList<>(); // Initialize as empty list
    private String status;
    @Schema(hidden = true)
    private UserDTO officer; // Reference to the officer

    @Data
    public static class LocationDTO {
        private double latitude;
        private double longitude;
        private String address;
    }

    @Data
    public static class RelatedSectionDTO {
        private String sectionCode;
        private String description;
        private double relevanceScore;
        private String reasoning;
    }

    @Data
    public static class LandmarkJudgmentDTO {
        private String title;
        private String summary;
        private String url;
    }
}

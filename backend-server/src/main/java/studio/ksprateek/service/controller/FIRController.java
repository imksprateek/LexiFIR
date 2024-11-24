package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.dto.FIRDTO;
import studio.ksprateek.service.dto.UserDTO;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.service.fir.FIRService;
import studio.ksprateek.service.utils.DTOConverter;
import studio.ksprateek.service.repository.UserRepository;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/firs")
@Tag(name = "3. FIRs", description = "Operations related to managing FIRs")
public class FIRController {

    @Autowired
    private FIRService firService;

    @Autowired
    private DTOConverter dtoConverter;

    @Autowired
    private UserRepository userRepository;

    // POST request for creating a new FIR (ID will be generated automatically)
    @PostMapping("/generate")
    @Operation(
            summary = "Create a new FIR",
            description = "Creates a new FIR and associates it with the officer. Returns the created FIR details."
    )
    @ApiResponse(
            responseCode = "200",
            description = "FIR created successfully",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = FIRDTO.class)
            )
    )
    @ApiResponse(
            responseCode = "400",
            description = "Invalid input data",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = ErrorResponse.class)
            )
    )
    public ResponseEntity<FIRDTO> createFIR(@RequestBody FIRDTO firDTO) {
        if (firDTO == null) {
            return ResponseEntity.badRequest().body(null);  // Handle the null case
        }

        // Get the userId from SecurityContextHolder
        String userId = getCurrentUserId();

        // Fetch the User entity by the userId
        User officer = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Ensure officerId is set in the DTO if it's missing (optional)
        if (firDTO.getOfficer() == null) {
            UserDTO officerDTO = new UserDTO();
            officerDTO.setId(officer.getId());
            officerDTO.setName(officer.getName());
            officerDTO.setEmail(officer.getEmail());
            // Set any other fields from the officer entity to officerDTO as needed
            firDTO.setOfficer(officerDTO);
        }

        // Set the officerId as the current User entity (not just the userId string)
        FIR fir = dtoConverter.toFIREntity(firDTO);
        fir.setOfficerId(officer);  // Set officerId to the User entity

        // Call the service to create the FIR and append the FIR ID to the officer's firIds
        FIR createdFIR = firService.createFIR(fir);

        // Convert the created FIR entity to DTO and return the response
        FIRDTO responseDTO = dtoConverter.toFIRDTO(createdFIR);
        return ResponseEntity.ok(responseDTO);
    }




    // PUT request for updating an existing FIR (ID should not be provided or updated)
    @PutMapping("/{id}")
    @Operation(
            summary = "Update an existing FIR",
            description = "Updates an existing FIR with the provided data. The FIR ID should not be modified."
    )
    @ApiResponse(
            responseCode = "200",
            description = "FIR updated successfully",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = FIRDTO.class)
            )
    )
    @ApiResponse(
            responseCode = "400",
            description = "Invalid input data",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = ErrorResponse.class)
            )
    )
    @ApiResponse(
            responseCode = "404",
            description = "FIR not found",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = ErrorResponse.class)
            )
    )
    public ResponseEntity<FIRDTO> updateFIR(@PathVariable String id, @RequestBody FIRDTO firDTO) {
        // Get the userId from SecurityContextHolder
        String userId = getCurrentUserId();

        // Fetch the User entity by the userId
        User officer = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Set the officerId as the current User entity (not just the userId string)
        FIR existingFIR = firService.getFIRById(id)
                .orElseThrow(() -> new RuntimeException("FIR not found"));

        FIR firToUpdate = dtoConverter.toFIREntity(firDTO);
        firToUpdate.setOfficerId(officer); // Set officerId to the User entity

        FIR updatedFIR = firService.updateFIR(id, firToUpdate);
        FIRDTO responseDTO = dtoConverter.toFIRDTO(updatedFIR);
        return ResponseEntity.ok(responseDTO);
    }

    // Utility method to get the current user ID from the SecurityContextHolder
    private String getCurrentUserId() {
        // Get the Authentication object from SecurityContextHolder
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // If the principal is an instance of String, return it directly
        if (principal instanceof String) {
            return (String) principal;
        }

        Optional<User> user = userRepository.findByUsername(((UserDetails) principal).getUsername());

        if(user.isPresent()) {
            // Otherwise, assuming it's a UserDetails object, get the username (user ID)
            return user.get().getId();
        }
        return "Error occurred while authorizing user";
    }

    @DeleteMapping("/{id}")
    @Operation(
            summary = "Delete an existing FIR",
            description = "Deletes an FIR by its ID. Returns a success message after deletion."
    )
    @ApiResponse(
            responseCode = "200",
            description = "FIR deleted successfully",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = String.class)
            )
    )
    @ApiResponse(
            responseCode = "404",
            description = "FIR not found",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = ErrorResponse.class)
            )
    )
    public ResponseEntity<String> deleteFIR(@PathVariable String id) {
        // Get the userId from SecurityContextHolder
        String userId = getCurrentUserId();

        // Fetch the User entity by the userId
        User officer = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Call the service to delete the FIR
        firService.deleteFIR(id);

        // Return a success message after deletion
        return ResponseEntity.ok("FIR with ID " + id + " deleted successfully.");
    }


    // GET request for getting all FIRs
    @GetMapping
    @Operation(
            summary = "Get all FIRs in Database",
            description = "Retrieves a list of all FIRs from the database."
    )
    @ApiResponse(
            responseCode = "200",
            description = "List of FIRs",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(
                            type = "array",
                            implementation = FIRDTO.class
                    )
            )
    )
    public List<FIRDTO> getAllFIRs() {
        List<FIR> firs = firService.getAllFIRs();
        return firs.stream()
                .map(dtoConverter::toFIRDTO)
                .collect(Collectors.toList());
    }

    // GET request for a specific FIR by ID
    @GetMapping("/{id}")
    @Operation(
            summary = "Get a specific FIR by ID",
            description = "Retrieves an FIR by its ID."
    )
    @ApiResponse(
            responseCode = "200",
            description = "FIR found",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = FIRDTO.class)
            )
    )
    @ApiResponse(
            responseCode = "404",
            description = "FIR not found",
            content = @Content(
                    mediaType = "application/json",
                    schema = @Schema(implementation = ErrorResponse.class)
            )
    )
    public ResponseEntity<FIRDTO> getFIRById(@PathVariable String id) {
        FIR fir = firService.getFIRById(id)
                .orElseThrow(() -> new RuntimeException("FIR not found"));
        FIRDTO responseDTO = dtoConverter.toFIRDTO(fir);
        return ResponseEntity.ok(responseDTO);
    }
}

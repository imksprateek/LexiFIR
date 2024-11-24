package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.dto.UserDTO;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.repository.UserRepository;
import studio.ksprateek.service.service.document.DocumentService;
import studio.ksprateek.service.service.user.UserDetailsServiceImpl;
import studio.ksprateek.service.utils.DTOConverter;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/users")
@Tag(name = "2. Users", description = "Operations related to Users")
public class UserController {

    @Autowired
    private UserDetailsServiceImpl userService;
    @Autowired
    private DocumentService fileService;
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DTOConverter dtoConverter;

    @GetMapping("/{id}")
    @Operation(
            summary = "Get user details by user ID",
            description = "Fetches the details of a user by their unique user ID. Returns the user details in a DTO format.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "Successfully retrieved user details.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = UserDTO.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "User with the specified ID not found."
                    )
            }
    )
    public ResponseEntity<UserDTO> getUserById(@PathVariable String id) {
        Optional<User> user = userService.getUserById(id);

        if (user.isPresent()) {
            UserDTO userDTO = dtoConverter.toUserDTO(user.get());
            return ResponseEntity.ok(userDTO);
        } else {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/{id}")
    @Operation(
            summary = "Update user details (partial updates supported)",
            description = "Updates user details, allowing partial updates. Fields not provided in the request will retain their existing values.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "User details updated successfully.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = UserDTO.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "User with the specified ID not found."
                    ),
                    @ApiResponse(
                            responseCode = "500",
                            description = "An error occurred while updating the user."
                    )
            }
    )
    public ResponseEntity<UserDTO> updateUser(@PathVariable String id, @RequestBody UserDTO userDTO) {
        // Fetch existing user to preserve fields not provided in the request
        User existingUser = userService.getUserById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Convert the DTO to an entity
        User userToUpdate = dtoConverter.toUserEntity(userDTO);

        // Perform the update logic (partial updates handled in service layer)
        User updatedUser = userService.updateUser(id, userToUpdate);

        // Convert the updated entity back to DTO
        return ResponseEntity.ok(dtoConverter.toUserDTO(updatedUser));
    }



    @DeleteMapping("/{id}")
    @Operation(
            summary = "Delete a user",
            description = "Deletes the user identified by the specified user ID.",
            responses = {
                    @ApiResponse(
                            responseCode = "204",
                            description = "User deleted successfully. No content returned."
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "User with the specified ID not found."
                    )
            }
    )
    public ResponseEntity<Void> deleteUser(@PathVariable String id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/firs")
    @Operation(
            summary = "Get all FIRs created by a user",
            description = "Fetches all FIRs created by the user identified by their ID. Returns a list of FIR DTOs.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "Successfully retrieved list of FIRs created by the user.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = List.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "400",
                            description = "User with the specified ID not found."
                    )
            }
    )
    public ResponseEntity<List<?>> getFIRsByUserId(@PathVariable String id) {
        List<FIR> firs = userService.getFIRsByUserId(id);
        List<?> firDTOs = firs.stream()
                .map(fir -> dtoConverter.toFIRDTO(fir)) // Convert FIR entities to DTOs
                .collect(Collectors.toList());
        return ResponseEntity.ok(firDTOs);
    }

    @GetMapping("Documents/all")
    @Operation(
            summary = "Get a list of all files uploaded by the user",
            description = "Fetches a list of all files uploaded by the user to an S3 bucket, returning only the file names.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "Successfully retrieved list of uploaded files.",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = List.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "500",
                            description = "An error occurred while retrieving the files."
                    )
            }
    )
    public ResponseEntity<List<String>> getAllS3ObjectsOfSpecificUser() {
        String userPrefix = "Documents/" + getCurrentUserId(); // Construct the prefix for the user's folder
        List<String> objectKeys = fileService.listObjects(userPrefix);

        // Extract file names from the object keys
        List<String> fileNames = objectKeys.stream()
                .map(key -> key.substring(key.lastIndexOf('/') + 1)) // Extract the file name
                .collect(Collectors.toList());

        return ResponseEntity.ok(fileNames); // Return the list of file names
    }


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
}

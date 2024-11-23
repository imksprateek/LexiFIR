package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.dto.UserDTO;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.service.user.UserDetailsServiceImpl;
import studio.ksprateek.service.utils.DTOConverter;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/users")
@Tag(name = "Users")
public class UserController {

    @Autowired
    private UserDetailsServiceImpl userService;

    @Autowired
    private DTOConverter dtoConverter;

    @GetMapping("/{id}")
    @Operation(summary = "Get user details by user ID")
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
    @Operation(summary = "Update user details (partial updates supported)")
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
    @Operation(summary = "Delete a user")
    public ResponseEntity<Void> deleteUser(@PathVariable String id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/firs")
    @Operation(summary = "Get all FIRs created by a user")
    public ResponseEntity<List<?>> getFIRsByUserId(@PathVariable String id) {
        List<FIR> firs = userService.getFIRsByUserId(id);
        List<?> firDTOs = firs.stream()
                .map(fir -> dtoConverter.toFIRDTO(fir)) // Convert FIR entities to DTOs
                .collect(Collectors.toList());
        return ResponseEntity.ok(firDTOs);
    }
}

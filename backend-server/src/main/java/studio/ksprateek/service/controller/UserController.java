package studio.ksprateek.service.controller;

import com.amazonaws.Response;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.service.user.UserDetailsServiceImpl;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/users")
@Tag(name = "Users")
public class UserController {

    @Autowired
    private UserDetailsServiceImpl userService;

    @GetMapping("/{id}")
    @Operation(summary = "Get user details by user ID")
    public ResponseEntity<User> getUserById(@PathVariable String id) {
        Optional<User> user = userService.getUserById(id);

        if(user.isPresent()){
            return ResponseEntity.ok(user.get());
        }else{
            return ResponseEntity.badRequest().body(user.get());
        }
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update user details")
    public User updateUser(@PathVariable String id, @RequestBody User user) {
        return userService.updateUser(id, user);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a user")
    public void deleteUser(@PathVariable String id) {
        userService.deleteUser(id);
    }

    @GetMapping("/{id}/firs")
    @Operation(summary = "Get all FIRs created by a user")
    public List<?> getFIRsByUserId(@PathVariable String id) {
        return userService.getFIRsByUserId(id);
    }
}


package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/health")
@Tag(name = "6. Health Check", description = "Know about server status")
public class Health {

    @Operation(summary = "To check server health")
    @GetMapping("")
    public ResponseEntity<?> healthCheck(){
        return ResponseEntity.ok("Up and running");
    }
}

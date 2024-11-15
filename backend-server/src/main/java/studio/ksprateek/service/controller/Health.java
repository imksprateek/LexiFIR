package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v3/health")
@Tag(name = "Health Check")
public class Health {

    @Operation(summary = "To check server health")
    @GetMapping("")
    public ResponseEntity<?> healthCheck(){
        return ResponseEntity.ok("Up and running");
    }
}

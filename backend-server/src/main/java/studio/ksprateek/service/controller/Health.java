package studio.ksprateek.service.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/health")
public class Health {
    @GetMapping("")
    public ResponseEntity<?> healthCheck(){
        return ResponseEntity.ok("Up and running");
    }
}

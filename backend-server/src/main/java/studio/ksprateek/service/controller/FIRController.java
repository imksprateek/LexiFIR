package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.service.fir.FIRService;

import java.util.List;

@RestController
@RequestMapping("/api/firs")
@Tag(name = "FIRs")
public class FIRController {

    @Autowired
    private FIRService firService;

    @PostMapping("/generate")
    @Operation(summary = "Create FIR")
    public FIR createFIR(@RequestBody FIR fir) {
        return firService.createFIR(fir);
    }

    @GetMapping
    @Operation(summary = "Get all FIRs")
    public List<FIR> getAllFIRs() {
        return firService.getAllFIRs();
    }

    @GetMapping("/{id}")
    @Operation(summary = "Search for a specific FIR by ID")
    public FIR getFIRById(@PathVariable String id) {
        return firService.getFIRById(id).orElseThrow(() -> new RuntimeException("FIR not found"));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update a specific FIR")
    public FIR updateFIR(@PathVariable String id, @RequestBody FIR fir) {
        return firService.updateFIR(id, fir);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a specific FIR")
    public void deleteFIR(@PathVariable String id) {
        firService.deleteFIR(id);
    }
}

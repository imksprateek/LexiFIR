package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.dto.FIRDTO;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.service.fir.FIRService;
import studio.ksprateek.service.utils.DTOConverter;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/firs")
@Tag(name = "FIRs")
public class FIRController {

    @Autowired
    private FIRService firService;

    @Autowired
    private DTOConverter dtoConverter;

    @PostMapping("/generate")
    @Operation(summary = "Create FIR")
    public ResponseEntity<FIRDTO> createFIR(@RequestBody FIRDTO firDTO) {
        FIR fir = dtoConverter.toFIREntity(firDTO);
        FIR createdFIR = firService.createFIR(fir);
        return ResponseEntity.ok(dtoConverter.toFIRDTO(createdFIR));
    }

    @GetMapping
    @Operation(summary = "Get all FIRs")
    public ResponseEntity<List<FIRDTO>> getAllFIRs() {
        List<FIR> firs = firService.getAllFIRs();
        List<FIRDTO> firDTOs = firs.stream()
                .map(dtoConverter::toFIRDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(firDTOs);
    }

    @GetMapping("/{id}")
    @Operation(summary = "Search for a specific FIR by ID")
    public ResponseEntity<FIRDTO> getFIRById(@PathVariable String id) {
        FIR fir = firService.getFIRById(id).orElseThrow(() -> new RuntimeException("FIR not found"));
        return ResponseEntity.ok(dtoConverter.toFIRDTO(fir));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update a specific FIR")
    public ResponseEntity<FIRDTO> updateFIR(@PathVariable String id, @RequestBody FIRDTO firDTO) {
        FIR fir = dtoConverter.toFIREntity(firDTO);
        FIR updatedFIR = firService.updateFIR(id, fir);
        return ResponseEntity.ok(dtoConverter.toFIRDTO(updatedFIR));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a specific FIR")
    public ResponseEntity<Void> deleteFIR(@PathVariable String id) {
        firService.deleteFIR(id);
        return ResponseEntity.noContent().build();
    }
}

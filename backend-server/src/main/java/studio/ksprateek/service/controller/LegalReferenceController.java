package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.entity.LegalReference;
import studio.ksprateek.service.service.legalref.LegalReferenceService;

import java.util.List;

@RestController
@RequestMapping("/api/legal-references")
@Tag(name = "Legal references")
public class LegalReferenceController {

    @Autowired
    private LegalReferenceService legalReferenceService;

    @GetMapping
    @Operation(summary = "Get all legal references")
    public List<LegalReference> getAllLegalReferences() {
        return legalReferenceService.getAllLegalReferences();
    }

    @PostMapping
    @Operation(summary = "Create legal reference")
    public LegalReference createLegalReference(@RequestBody LegalReference legalReference) {
        return legalReferenceService.addLegalReference(legalReference);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update legal reference")
    public LegalReference updateLegalReference(@PathVariable String id, @RequestBody LegalReference legalReference) {
        return legalReferenceService.updateLegalReference(id, legalReference);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete a legal reference")
    public void deleteLegalReference(@PathVariable String id) {
        legalReferenceService.deleteLegalReference(id);
    }
}

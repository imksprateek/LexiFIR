package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.entity.UploadedDocument;
import studio.ksprateek.service.service.document.DocumentService;
import studio.ksprateek.service.service.fir.FIRService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/firs/{firId}/documents")
@Tag(name = "Document files")
public class DocumentController {

    @Autowired
    private DocumentService documentService;
    @Autowired
    private FIRService firService;

    @PostMapping
    @Operation(summary = "Upload a Document file")
    public UploadedDocument uploadDocument(@PathVariable String firId, @RequestBody UploadedDocument document) {
        Optional<FIR> fir = firService.getFIRById(firId);
        if(fir.isPresent()){
            document.setFirId(fir.get());
        }
        return documentService.uploadDocument(document);
    }

    @GetMapping
    @Operation(summary = "Get an uploaded Document file")
    public List<UploadedDocument> getDocumentsByFIR(@PathVariable String firId) {
        return documentService.getDocumentsByFIRId(firId);
    }
}

package studio.ksprateek.service.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import studio.ksprateek.service.dto.CaseReportRequest;
import studio.ksprateek.service.dto.LegalAnalysisDTO;
import studio.ksprateek.service.service.legalref.LegalAnalysisService;

@RestController
@RequestMapping("/api/legal")
public class LegalAnalysisController {
    @Autowired
    private LegalAnalysisService legalAnalysisService;

    public LegalAnalysisController(LegalAnalysisService legalAnalysisService) {
        this.legalAnalysisService = legalAnalysisService;
    }

    @PostMapping
    public ResponseEntity<LegalAnalysisDTO> processLegalAnalysis(@RequestBody CaseReportRequest caseReport) {
        LegalAnalysisDTO legalAnalysis = legalAnalysisService.processLegalAnalysis(caseReport);
        return ResponseEntity.ok(legalAnalysis);
    }
}
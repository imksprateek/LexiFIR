package studio.ksprateek.service.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import studio.ksprateek.service.dto.CaseReportRequest;
import studio.ksprateek.service.payload.responses.CaseReportResponse;
import studio.ksprateek.service.service.fir.CaseReportService;

@RestController
@RequestMapping(path = "/api/")
public class CaseReportController {

    @Autowired
    private CaseReportService caseReportService;

    @PostMapping("/generate-report")
    public ResponseEntity<CaseReportResponse> generateReport(@RequestBody CaseReportRequest request) {
        return ResponseEntity.ok(caseReportService.fetchFIRData(request));
    }
}

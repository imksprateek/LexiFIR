package studio.ksprateek.service.service.legalref;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import studio.ksprateek.service.dto.CaseReportRequest;
import studio.ksprateek.service.dto.LegalAnalysisDTO;

@Service
public class LegalAnalysisService {
    @Autowired
    private RestTemplate restTemplate;
    @Autowired
    private ObjectMapper objectMapper;

    @Value("http://ai.ksprateek.studio/generate-case-report")
    private String aiMicroserviceUrl;

    public LegalAnalysisService(RestTemplate restTemplate, ObjectMapper objectMapper) {
        this.restTemplate = restTemplate;
        this.objectMapper = objectMapper;
    }

    public LegalAnalysisDTO processLegalAnalysis(CaseReportRequest caseReport) {
        try {
            // Make API call to AI microservice
            ResponseEntity<String> response = restTemplate.postForEntity(
                    aiMicroserviceUrl,
                    caseReport,
                    String.class
            );

            System.out.println(response);

            // Parse the entire response as a JSON node
            JsonNode rootNode = objectMapper.readTree(response.getBody());

            // Extract the legal analysis field
            JsonNode legalAnalysisNode = rootNode.get("relatedSections & Landmark judgemnts");

            if (legalAnalysisNode == null) {
                throw new RuntimeException("Legal analysis not found in response");
            }

            // Get the string value and remove all backslash characters
            String legalAnalysisJson = legalAnalysisNode.asText()
//                    .replace("\\", "")
                    ;

            System.out.println(legalAnalysisJson);

            // Parse the cleaned JSON string to LegalAnalysisDTO
            return objectMapper.readValue(legalAnalysisJson, LegalAnalysisDTO.class);

        } catch (Exception e) {
            // Log the full exception for debugging
            e.printStackTrace();
            throw new RuntimeException("Error processing legal analysis: " + e.getMessage(), e);
        }
    }
}

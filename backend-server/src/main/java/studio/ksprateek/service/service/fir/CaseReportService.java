package studio.ksprateek.service.service.fir;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import studio.ksprateek.service.dto.CaseReportRequest;
import studio.ksprateek.service.payload.responses.CaseReportResponse;

@Service
public class CaseReportService {
    @Autowired
    private RestTemplate restTemplate;
    private ObjectMapper objectMapper; // To handle JSON processing

    public CaseReportResponse fetchFIRData(CaseReportRequest firRequest) {
        String url = "http://ai.ksprateek.studio/generate-case-report";

        // Create HTTP headers and set content type to JSON
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Wrap the request body in an HttpEntity
        HttpEntity<CaseReportRequest> requestEntity = new HttpEntity<>(firRequest, headers);

        // Send the POST request to the external API and receive raw response as JsonNode
        ResponseEntity<JsonNode> responseEntity = restTemplate.postForEntity(url, requestEntity, JsonNode.class);

        JsonNode externalApiResponse = responseEntity.getBody();

        // Map the fields from the external API response to the FIRResponse object
        CaseReportResponse firResponse = new CaseReportResponse();
        if (externalApiResponse != null) {
            firResponse.setCaseTitle(externalApiResponse.get("caseTitle").asText());
            firResponse.setIncidentDescription(externalApiResponse.get("incidentDescription").asText());

            // Handle nested location object
            JsonNode locationNode = externalApiResponse.get("location");
            if (locationNode != null) {
                CaseReportResponse.Location location = new CaseReportResponse.Location();
                location.setAddress(locationNode.get("address").asText());
                location.setLatitude(locationNode.get("latitude").asDouble());
                location.setLongitude(locationNode.get("longitude").asDouble());
                firResponse.setLocation(location);
            }
            System.out.println(externalApiResponse);

            // Map the external field "relatedSections & Landmark judgements" to "relatedSectionsAndLandmarkJudgments"
            if (externalApiResponse.has("relatedSections & Landmark judgemnts")) {
                firResponse.setRelatedSectionsAndLandmarkJudgments(
                        externalApiResponse.get("relatedSections & Landmark judgemnts").asText());
            }
        }

        return firResponse;
    }
}

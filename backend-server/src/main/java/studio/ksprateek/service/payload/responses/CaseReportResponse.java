package studio.ksprateek.service.payload.responses;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class CaseReportResponse {
    private String caseTitle;
    private String incidentDescription;
    private Location location;
    private String relatedSectionsAndLandmarkJudgments;

    @Data
    public static class Location {
        private String address;
        private double latitude;
        private double longitude;
    }
}

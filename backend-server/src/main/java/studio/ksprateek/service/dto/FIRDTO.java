package studio.ksprateek.service.dto;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class FIRDTO {
    private String id;
    private String caseTitle;
    private String incidentDescription;
    private LocalDateTime incidentDate;
    private LocationDTO location;
    private List<RelatedSectionDTO> relatedSections;
    private List<LandmarkJudgmentDTO> landmarkJudgments;
    private List<ReviewHistoryDTO> reviewHistory;
    private String status;
    private UserDTO officer; // Reference to the officer

    @Data
    public static class LocationDTO {
        private double latitude;
        private double longitude;
        private String address;
    }

    @Data
    public static class RelatedSectionDTO {
        private String sectionCode;
        private String description;
        private double relevanceScore;
        private String reasoning;
    }

    @Data
    public static class LandmarkJudgmentDTO {
        private String title;
        private String summary;
        private String url;
    }

    @Data
    public static class ReviewHistoryDTO {
        private String moderatorId;
        private LocalDateTime reviewDate;
        private String comments;
        private String status;
    }
}

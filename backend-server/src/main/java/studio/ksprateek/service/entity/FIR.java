package studio.ksprateek.service.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "fir")
@Data
@Builder
public class FIR {
    @Id
    private String id;

    @DBRef
    private User officerId;

    private String caseTitle;
    private String incidentDescription;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    private LocalDateTime incidentDate;
    private Location location;
    private List<RelatedSection> relatedSections;
    private List<LandmarkJudgment> landmarkJudgments;
    private String status;

    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    @Data
    public static class Location {
        private double latitude;
        private double longitude;
        private String address;
    }

    @Data
    public static class RelatedSection {
        private String sectionCode;
        private String description;
        private double relevanceScore;
        private String reasoning;
    }

    @Data
    public static class LandmarkJudgment {
        private String title;
        private String summary;
        private String url;
    }
}
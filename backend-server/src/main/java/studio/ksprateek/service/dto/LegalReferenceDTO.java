package studio.ksprateek.service.dto;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class LegalReferenceDTO {
    private String id;
    private String type;
    private String sectionCode;
    private String title;
    private String description;
    private List<RelatedJudgementDTO> relatedJudgments;
    private String firId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Data
    public static class LandmarkJudgmentDTO {
        private String title;
        private String summary;
        private String url;
    }
}

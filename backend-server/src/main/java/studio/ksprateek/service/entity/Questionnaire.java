package studio.ksprateek.service.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "questionnaires")
@Data
@Builder
public class Questionnaire {
    @Id
    private String id;

    private String incidentType;
    private List<Question> questions;
    private List<String> associatedLegalSections;

    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    @Data
    public static class Question {
        private String questionText;
        private String field;
        private String responseType;
    }
}
package studio.ksprateek.service.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "trainingModules")
@Data
@Builder
public class TrainingModule {
    @Id
    private String id;

    private String moduleTitle;
    private String content;
    private List<Resource> resources;
    private List<UserProgress> userProgress;

    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    @Data
    public static class Resource {
        private String type;
        private String url;
    }

    @Data
    public static class UserProgress {
        @DBRef
        private User userId;
        private double progress;
        private LocalDateTime lastAccessed;
    }
}
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

@Document(collection = "legalReference")
@Data
@Builder
public class LegalReference {
    @Id
    private String id;

    private String type;
    private String sectionCode;
    private String title;
    private String description;
    private List<RelatedJudgement> relatedJudgments;

    @DBRef
    private FIR firId;

    @CreatedDate
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;
}
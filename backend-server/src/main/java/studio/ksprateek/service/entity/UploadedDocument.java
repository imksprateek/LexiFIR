package studio.ksprateek.service.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "uploadedDocuments")
@Data
@Builder
public class UploadedDocument {
    @Id
    private String id;

    @DBRef
    private FIR firId;

    private String fileUrl;
    private String fileName;
    private String extractedText;

    @CreatedDate
    private LocalDateTime createdAt;
}
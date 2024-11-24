package studio.ksprateek.service.dto;

import lombok.Data;

@Data
public class DocumentDTO {
    private String id;
    private String firId; // Reference to FIR
    private String fileUrl; // S3 URL
    private String fileName;
    private String extractedText;
}

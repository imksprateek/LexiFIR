package studio.ksprateek.service.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "otp")
@Builder
@Data
public class Otp {
    @Id
    private String id;
    private String otp;
    private String email;
    @CreatedDate
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
}

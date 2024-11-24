package studio.ksprateek.service.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "chatlogs")
@Data
@Builder
public class ChatLog {
    @Id
    private String id;

    @DBRef
    private User userId;

    private String query;
    private String response;
    private String context;

    @CreatedDate
    private LocalDateTime timestamp;
}
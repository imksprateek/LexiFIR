package studio.ksprateek.service.dto;


import lombok.Data;

@Data
public class NotificationDTO {
    private String id;
    private String userId; // Reference to User
    private String title;
    private String message;
    private boolean isRead;
}

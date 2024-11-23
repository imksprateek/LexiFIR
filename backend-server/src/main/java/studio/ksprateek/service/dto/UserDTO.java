package studio.ksprateek.service.dto;

import lombok.Data;

@Data
public class UserDTO {
    private String id;
    private String name;
    private String email;
    private String languagePreference;
    private String roleId; // Role reference
}

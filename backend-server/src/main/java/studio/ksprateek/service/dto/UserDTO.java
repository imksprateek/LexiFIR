package studio.ksprateek.service.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.util.List;

@Data
public class UserDTO {
    private String id;
    private String username;
    private String email;
    private String name;
    private String languagePreference;
    private List<String> roleIds;  // Role reference
}

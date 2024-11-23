package studio.ksprateek.service.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.util.List;

@Data
public class UserDTO {
    private String id;
    private String name;
    private String email;
    private String username;
    private String languagePreference;
    private List<String> roleNames; // Store role names instead of IDs
}

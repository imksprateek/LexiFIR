package studio.ksprateek.service.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.List;

@Data
public class UserDTO {
    @Schema(hidden = true)
    private String id;
    private String name;
    private String email;
    private String username;
    private String languagePreference;
    private List<String> roleNames; // Store role names instead of IDs
}

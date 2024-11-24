package studio.ksprateek.service.dto;

import lombok.Data;
import java.util.List;

@Data
public class QuestionnaireDTO {
    private String id;
    private String incidentType; // e.g., Theft, Assault
    private List<QuestionDTO> questions;

    @Data
    public static class QuestionDTO {
        private String questionText;
        private String field; // Field in FIR to populate
        private String responseType; // text, date, etc.
    }
}

package studio.ksprateek.service.dto;

import lombok.Data;
import java.util.List;

@Data
public class TrainingModuleDTO {
    private String id;
    private String moduleTitle;
    private String content;
    private List<ResourceDTO> resources;

    @Data
    public static class ResourceDTO {
        private String type; // PDF, Video, etc.
        private String url;
    }
}

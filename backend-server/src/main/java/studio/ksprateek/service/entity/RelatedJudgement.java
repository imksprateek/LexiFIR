package studio.ksprateek.service.entity;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RelatedJudgement {
    private String title;
    private String summary;
    private String url;
}
package studio.ksprateek.service.dto;

import lombok.Data;

@Data
public class CaseReportRequest {
    private String what;
    private String where;
    private String when;
    private String why;
    private String who;
    private String how;
    private String witness;
    private String weapon;
}

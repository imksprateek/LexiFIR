package studio.ksprateek.service.entity;

import lombok.Builder;
import lombok.Data;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

@Document(collection = "crimeRecords")
@Data
@Builder
public class CrimeRecord {
    @Id
    private String id;

    private String caseNumber;
    private String summary;
    private LocalDateTime dateResolved;

    @DBRef
    private List<FIR> relatedFIRs;
}
package studio.ksprateek.service.payload.requests;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class TextToSpeechRequest {
    private String text;
}


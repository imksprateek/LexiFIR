package studio.ksprateek.service.payload.requests;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@AllArgsConstructor
public class TextToSpeechRequest {
    private String textToTranscribe;
}


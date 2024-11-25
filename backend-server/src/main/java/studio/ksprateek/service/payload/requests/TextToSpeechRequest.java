package studio.ksprateek.service.payload.requests;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class TextToSpeechRequest {

    @NotNull(message = "Text must not be null")
    private String text;

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }
}


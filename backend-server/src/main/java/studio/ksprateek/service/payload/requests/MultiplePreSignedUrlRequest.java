package studio.ksprateek.service.payload.requests;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MultiplePreSignedUrlRequest {
    private String originalFileName;
}
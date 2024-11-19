package studio.ksprateek.service.payload.responses;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import studio.ksprateek.service.entity.User;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AuthResponse {
    private int statusCode;
    private String responseMessage;
    private User userInfo;
    private OtpResponse otpResponse;
}
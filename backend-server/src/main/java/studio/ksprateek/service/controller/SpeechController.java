package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import studio.ksprateek.service.payload.requests.TextToSpeechRequest;
import studio.ksprateek.service.service.speech.SpeechService;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/speech")
@Tag(name = "Speech Operations", description = "APIs for Text-to-Speech and Speech-to-Text using AWS Polly and Transcribe")
public class SpeechController {

    private final SpeechService speechService;

    public SpeechController(SpeechService speechService) {
        this.speechService = speechService;
    }

    @PostMapping("/text-to-speech")
//    @Operation(
//            summary = "Convert text to speech",
//            description = "Converts a given text string into an MP3 audio file using AWS Polly.",
//            requestBody = @RequestBody(
//                    description = "The text to convert to speech",
//                    required = true,
//                    content = @Content(schema = @Schema(implementation = TextToSpeechRequest.class))
//            ),
//            responses = {
//                    @ApiResponse(responseCode = "200", description = "Audio file generated successfully",
//                            content = @Content(schema = @Schema(type = "string", format = "binary"))),
//                    @ApiResponse(responseCode = "400", description = "Bad Request"),
//                    @ApiResponse(responseCode = "500", description = "Internal Server Error")
//            }
//    )
    public ResponseEntity<?> textToSpeech(@RequestBody TextToSpeechRequest request) {
        try {
            byte[] audioBytes = speechService.textToSpeech(request.getText());
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=output.mp3")
                    .body(audioBytes);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }


    @PostMapping(path = "/speech-to-text",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(
            summary = "Convert speech to text",
            description = "Transcribes the speech from an uploaded audio file into text using AWS Transcribe.",
            responses = {
                    @ApiResponse(responseCode = "200", description = "Transcription completed successfully",
                            content = @Content(schema = @Schema(type = "string"))),
                    @ApiResponse(responseCode = "500", description = "Internal Server Error")
            }
    )
    public ResponseEntity<String> speechToText(@RequestParam("file") MultipartFile file) {
        try {
            String transcription = speechService.speechToText(file);
            return ResponseEntity.ok(transcription);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }
}


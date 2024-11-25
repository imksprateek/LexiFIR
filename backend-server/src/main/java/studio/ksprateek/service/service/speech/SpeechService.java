package studio.ksprateek.service.service.speech;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.polly.PollyClient;
import software.amazon.awssdk.services.polly.model.OutputFormat;
import software.amazon.awssdk.services.polly.model.SynthesizeSpeechRequest;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.transcribe.TranscribeClient;
import software.amazon.awssdk.services.transcribe.model.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.UUID;

@Service
public class SpeechService {

    @Autowired
    private PollyClient pollyClient;
    @Autowired
    private TranscribeClient transcribeClient;
    @Autowired
    private S3Client s3Client;

    @Value("${aws.speech.bucket}")
    private String bucketName;

    public SpeechService(PollyClient pollyClient, TranscribeClient transcribeClient, S3Client s3Client) {
        this.pollyClient = pollyClient;
        this.transcribeClient = transcribeClient;
        this.s3Client = s3Client;
    }

    public byte[] textToSpeech(String text) {
        SynthesizeSpeechRequest request = SynthesizeSpeechRequest.builder()
                .text(text)
                .voiceId("Kajal") // Replace with the desired voice
                .outputFormat(OutputFormat.MP3)
                .build();

        try (var responseInputStream = pollyClient.synthesizeSpeech(request)) {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = responseInputStream.read(buffer)) != -1) {
                byteArrayOutputStream.write(buffer, 0, bytesRead);
            }
            return byteArrayOutputStream.toByteArray();
        } catch (IOException e) {
            throw new RuntimeException("Error while synthesizing speech: " + e.getMessage(), e);
        }
    }

    // Speech-to-Text (STT)
    public String speechToText(MultipartFile file) throws IOException, InterruptedException {
        String fileName = file.getOriginalFilename();
        String s3Key = "uploads/" + fileName;

        // Upload file to S3
        s3Client.putObject(PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(s3Key)
                        .build(),
                RequestBody.fromBytes(file.getBytes()));

        // Start Transcription Job
        String jobName = "TranscriptionJob_" + UUID.randomUUID();
        String mediaUri = "s3://" + bucketName + "/" + s3Key;

        StartTranscriptionJobRequest transcriptionRequest = StartTranscriptionJobRequest.builder()
                .transcriptionJobName(jobName)
                .media(Media.builder().mediaFileUri(mediaUri).build())
                .languageCode(LanguageCode.EN_IN) // Change language code if needed
                .build();

        transcribeClient.startTranscriptionJob(transcriptionRequest);

        // Wait and get the transcription result
        while (true) {
            GetTranscriptionJobResponse jobResponse = transcribeClient.getTranscriptionJob(
                    GetTranscriptionJobRequest.builder()
                            .transcriptionJobName(jobName)
                            .build());

            TranscriptionJob transcriptionJob = jobResponse.transcriptionJob();

            if (transcriptionJob.transcriptionJobStatus() == TranscriptionJobStatus.COMPLETED) {
                String transcriptUri = transcriptionJob.transcript().transcriptFileUri();
                try (InputStream inputStream = new URL(transcriptUri).openStream()) {
                    return new String(inputStream.readAllBytes());
                }
            } else if (transcriptionJob.transcriptionJobStatus() == TranscriptionJobStatus.FAILED) {
                throw new RuntimeException("Transcription failed: " + transcriptionJob.failureReason());
            }

            // Poll every 2 seconds
            Thread.sleep(2000);
        }
    }
}
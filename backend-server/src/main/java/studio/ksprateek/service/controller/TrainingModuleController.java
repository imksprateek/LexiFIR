package studio.ksprateek.service.controller;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import software.amazon.awssdk.core.async.SdkPublisher;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import studio.ksprateek.service.entity.TrainingModule;
import studio.ksprateek.service.service.training.TrainingModuleService;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/training")
@Tag(name = "5. Training modules", description = "Operations related to Training Modules, Letcures and resources")
public class TrainingModuleController {

    @Autowired
    private TrainingModuleService trainingModuleService;

    @Value("${aws.region}")
    private String awsRegion;
    @Value("${aws.bucket}")
    private String bucket;
    @Value("${aws.secretKey}")
    private String key;


    @PostMapping(value = "/upload/{moduleName}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(
            summary = "Upload a large file to S3 (ADMIN ONLY)",
            description = "Upload a file for a specific training module. The file will be stored in S3 with the path `Training/ModuleName/fileName`.",
            parameters = {
                    @Parameter(name = "moduleName", description = "The name of the training module", required = true)
            },
            requestBody = @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    description = "The file to be uploaded",
                    content = @Content(mediaType = MediaType.MULTIPART_FORM_DATA_VALUE)
            )
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "File uploaded successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid input"),
            @ApiResponse(responseCode = "500", description = "Server error")
    })
    public ResponseEntity<String> uploadFile(
            @RequestParam("file") MultipartFile file,
            @PathVariable("moduleName") String moduleName) {
        try {
            String filePath = trainingModuleService.uploadLargeFile(file, moduleName);
            return ResponseEntity.ok("File uploaded successfully to path: " + filePath);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error during file upload: " + e.getMessage());
        }
    }

    @GetMapping(value = "/download/{moduleName}/{fileName}")
    @Operation(
            summary = "Download a file from S3 (USER)",
            description = "Stream and download a file from S3 for a specific training module. The file path is constructed as `Training/ModuleName/fileName`.",
            parameters = {
                    @Parameter(name = "moduleName", description = "The name of the training module", required = true),
                    @Parameter(name = "fileName", description = "The name of the file to download", required = true)
            }
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "File downloaded successfully",
                    content = @Content(mediaType = MediaType.APPLICATION_OCTET_STREAM_VALUE)),
            @ApiResponse(responseCode = "404", description = "File not found"),
            @ApiResponse(responseCode = "500", description = "Server error")
    })
    public ResponseEntity<StreamingResponseBody> downloadFile(
            @PathVariable("moduleName") String moduleName,
            @PathVariable("fileName") String fileName) {

        String filePath = "Training/" + moduleName + "/" + fileName;

        InputStream fileStream = trainingModuleService.streamFileFromS3(filePath);

        StreamingResponseBody responseBody = outputStream -> {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fileStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
            fileStream.close();
        };

        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"");
        headers.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE);

        return ResponseEntity.ok()
                .headers(headers)
                .body(responseBody);
    }

    @GetMapping("/modules")
    @Operation(
            summary = "Get all training modules and their files",
            description = "This endpoint retrieves a list of all available training modules and their respective files stored in S3. Each module is a folder, and the files in each module are returned as a list of file names.",
            responses = {
                    @ApiResponse(
                            responseCode = "200",
                            description = "Successfully retrieved the list of modules and their files",
                            content = @Content(
                                    mediaType = "application/json",
                                    schema = @Schema(implementation = Map.class)
                            )
                    ),
                    @ApiResponse(
                            responseCode = "500",
                            description = "Internal server error. Something went wrong while retrieving the modules."
                    )
            }
    )
    public ResponseEntity<Map<String, List<String>>> getAllTrainingModules() {
        Map<String, List<String>> modules = trainingModuleService.getAllModulesAndFiles();
        return ResponseEntity.ok(modules);
    }
}

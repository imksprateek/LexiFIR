package studio.ksprateek.service.controller;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import software.amazon.awssdk.services.s3.S3Client;
import studio.ksprateek.service.entity.TrainingModule;
import studio.ksprateek.service.service.training.TrainingModuleService;

import java.util.List;

@RestController
@RequestMapping("/api/training-modules")
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

    @GetMapping(value = "/{fileName}", produces = { MediaType.APPLICATION_OCTET_STREAM_VALUE })
    @Operation(summary = "Get stream data of a training module video")
    public ResponseEntity<StreamingResponseBody> getObject(@PathVariable String fileName, HttpServletRequest request) {
        try {
            AmazonS3 s3client = AmazonS3ClientBuilder.standard().withRegion(awsRegion).build();

//            String uri = request.getRequestURI();
//            String uriParts[] = uri.split("/", 2)[1].split("/", 2);
//
//            String bucket = uriParts[0];
////            String key = uriParts[1];
//            System.out.println("Fetching " + uri);
            S3Object object = s3client.getObject(bucket, key);
            S3ObjectInputStream finalObject = object.getObjectContent();

            final StreamingResponseBody body = outputStream -> {
                int numberOfBytesToWrite = 0;
                byte[] data = new byte[1024];
                while ((numberOfBytesToWrite = finalObject.read(data, 0, data.length)) != -1) {
                    outputStream.write(data, 0, numberOfBytesToWrite);
                }
                finalObject.close();
            };
            return new ResponseEntity<StreamingResponseBody>(body, HttpStatus.OK);
        } catch (Exception e) {
            System.err.println("Error "+ e.getMessage());
            return new ResponseEntity<StreamingResponseBody>(HttpStatus.BAD_REQUEST);
        }

    }

    @GetMapping
    @Operation(summary = "Get all training modules")
    public List<TrainingModule> getAllModules() {
        return trainingModuleService.getAllTrainingModules();
    }

    @PostMapping
    @Operation(summary = "Add training modules")
    public TrainingModule addTrainingModule(@RequestBody TrainingModule trainingModule) {
        return trainingModuleService.addTrainingModule(trainingModule);
    }

    @DeleteMapping
    @Operation(summary = "Delete a training module")
    public void deleteTrainingModule(@RequestBody TrainingModule trainingModule){
        trainingModuleService.deleteTrainingModule(trainingModule.getId());
    }
}

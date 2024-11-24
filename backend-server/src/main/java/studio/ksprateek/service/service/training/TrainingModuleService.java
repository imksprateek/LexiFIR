package studio.ksprateek.service.service.training;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.ResponseInputStream;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.core.sync.ResponseTransformer;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TrainingModuleService {

    @Autowired
    private S3Client s3Client;

    @Value("${aws.bucket}")
    private String BUCKET_NAME;

    public String uploadLargeFile(MultipartFile file, String moduleName) throws IOException {
        String filePath = "Training/" + moduleName + "/" + file.getOriginalFilename();

        // Step 1: Start multipart upload
        CreateMultipartUploadRequest createMultipartUploadRequest = CreateMultipartUploadRequest.builder()
                .bucket(BUCKET_NAME)
                .key(filePath)
                .build();

        CreateMultipartUploadResponse createMultipartUploadResponse = s3Client.createMultipartUpload(createMultipartUploadRequest);
        String uploadId = createMultipartUploadResponse.uploadId();

        List<CompletedPart> completedParts = new ArrayList<>();
        File tempFile = File.createTempFile("upload-", file.getOriginalFilename());
        file.transferTo(tempFile);

        try (RandomAccessFile raf = new RandomAccessFile(tempFile, "r")) {
            long partSize = 5 * 1024 * 1024; // 5 MB
            long fileSize = tempFile.length();
            int partNumber = 1;

            while (fileSize > 0) {
                long sizeToUpload = Math.min(partSize, fileSize);
                byte[] buffer = new byte[(int) sizeToUpload];
                raf.read(buffer);

                // Step 2: Upload each part
                UploadPartRequest uploadPartRequest = UploadPartRequest.builder()
                        .bucket(BUCKET_NAME)
                        .key(filePath)
                        .uploadId(uploadId)
                        .partNumber(partNumber)
                        .contentLength(sizeToUpload)
                        .build();

                UploadPartResponse uploadPartResponse = s3Client.uploadPart(uploadPartRequest, RequestBody.fromBytes(buffer));

                completedParts.add(CompletedPart.builder()
                        .partNumber(partNumber)
                        .eTag(uploadPartResponse.eTag())
                        .build());

                partNumber++;
                fileSize -= sizeToUpload;
            }

            // Step 3: Complete the upload
            CompleteMultipartUploadRequest completeMultipartUploadRequest = CompleteMultipartUploadRequest.builder()
                    .bucket(BUCKET_NAME)
                    .key(filePath)
                    .uploadId(uploadId)
                    .multipartUpload(CompletedMultipartUpload.builder().parts(completedParts).build())
                    .build();

            s3Client.completeMultipartUpload(completeMultipartUploadRequest);

        } catch (Exception e) {
            // Step 4: Abort the upload if there's an error
            AbortMultipartUploadRequest abortMultipartUploadRequest = AbortMultipartUploadRequest.builder()
                    .bucket(BUCKET_NAME)
                    .key(filePath)
                    .uploadId(uploadId)
                    .build();
            s3Client.abortMultipartUpload(abortMultipartUploadRequest);
            throw new IOException("Failed to upload large file", e);
        } finally {
            tempFile.delete(); // Clean up temporary file
        }

        return filePath;
    }

    public InputStream streamFileFromS3(String filePath) {
        GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                .bucket(BUCKET_NAME)
                .key(filePath)
                .build();

        ResponseInputStream<GetObjectResponse> responseInputStream = s3Client.getObject(getObjectRequest, ResponseTransformer.toInputStream());
        return responseInputStream;
    }

    public Map<String, List<String>> getAllModulesAndFiles() {
        Map<String, List<String>> modules = new HashMap<>();

        // Initial request to fetch all objects under "Training/"
        ListObjectsV2Request request = ListObjectsV2Request.builder()
                .bucket(BUCKET_NAME)
                .prefix("Training/") // Root folder for training modules
                .build();

        ListObjectsV2Response response;
        do {
            response = s3Client.listObjectsV2(request);

            for (S3Object s3Object : response.contents()) {
                String key = s3Object.key();

                // Skip the root folder itself and directories
                if (key.equals("Training/") || key.endsWith("/")) {
                    continue;
                }

                // Extract module name and file name
                String relativePath = key.substring("Training/".length());
                String moduleName = relativePath.split("/")[0]; // Module folder name
                String fileName = relativePath.substring(relativePath.lastIndexOf("/") + 1);

                // Add file to the respective module
                modules.computeIfAbsent(moduleName, k -> new ArrayList<>()).add(fileName);
            }

            // Pagination handling
            request = request.toBuilder()
                    .continuationToken(response.nextContinuationToken())
                    .build();

        } while (response.isTruncated());

        return modules;
    }
}

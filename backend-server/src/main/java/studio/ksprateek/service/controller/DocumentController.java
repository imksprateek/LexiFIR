package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import software.amazon.awssdk.http.SdkHttpMethod;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.repository.UserRepository;
import studio.ksprateek.service.service.document.AccessType;
import studio.ksprateek.service.service.document.DocumentService;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static studio.ksprateek.service.service.document.DocumentService.buildFilename;

@RestController
@RequestMapping(path = "/api/documents")
@Tag(name = "4. Document files", description = "Operations for managing user uploaded documents")
public class DocumentController {
    @Autowired
    private DocumentService fileService;
    @Autowired
    private UserRepository userRepository;

    /**
     * Generates a presigned GET URL for a file.
     */
//    @GetMapping("/{filename}")
//    public ResponseEntity<String> getUrl(@PathVariable String filename) {
//        String url = fileService.generatePreSignedUrl(filename, SdkHttpMethod.GET, null);
//        return ResponseEntity.ok(url);
//    }

//    /**
//     * Generates a presigned PUT URL with specified access type.
//     */
//    @PostMapping("/pre-signed-url")
//    public ResponseEntity<Map<String, Object>> generateUrl(
//            @RequestParam(name = "filename", required = false, defaultValue = "") String filename,
//            @RequestParam(name = "accessType", required = false, defaultValue = "PRIVATE") AccessType accessType) {
//        filename = buildFilename(filename);
//        String url = fileService.generatePreSignedUrl(filename, SdkHttpMethod.PUT, accessType);
//        return ResponseEntity.ok(Map.of("url", url, "file", filename));
//    }

    /**
     * Uploads a file with specified access type over java.
     */
    @RequestMapping(
            path = "/upload",
            method = RequestMethod.POST,
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Operation(summary = "Upload a file. Make sure to set Access Type to Public to enable download for the file")
    public ResponseEntity<String> uploadFile(
            @RequestParam("file") MultipartFile file,
            @RequestParam(name = "accessType", required = false, defaultValue = "PRIVATE") AccessType accessType) throws IOException {
        String userId = getCurrentUserId();
        String fileName = fileService.uploadMultipartFile(file, accessType ,userId);
        return ResponseEntity.ok("File name: " + fileName);
    }

    /**
     * Downloads a file over java.
     */
    @GetMapping("/download/{fileName}")
    @Operation(summary = "Download a pre-uploaded public document using filename")
    public ResponseEntity<StreamingResponseBody> downloadFile(@PathVariable("fileName") String fileName) throws Exception {
        return fileService.downloadFileResponse(fileName);
    }


    private String getCurrentUserId() {
        // Get the Authentication object from SecurityContextHolder
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // If the principal is an instance of String, return it directly
        if (principal instanceof String) {
            return (String) principal;
        }

        Optional<User> user = userRepository.findByUsername(((UserDetails) principal).getUsername());

        if(user.isPresent()) {
            // Otherwise, assuming it's a UserDetails object, get the username (user ID)
            return user.get().getId();
        }
        return "Error occurred while authorizing user";
    }

    @GetMapping("{userID}/all")
    public ResponseEntity<List<String>> getAllS3ObjectsOfSpecificUser(@PathVariable String userID){
        return ResponseEntity.ok(fileService.listObjects("Documents/" + userID));
    }
}

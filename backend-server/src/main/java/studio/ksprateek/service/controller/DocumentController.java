package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.entity.UploadedDocument;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.payload.responses.FileUploadResponse;
import studio.ksprateek.service.repository.UserRepository;
import studio.ksprateek.service.service.document.DocumentService;
import studio.ksprateek.service.service.fir.FIRService;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(path = "/api/firs/{firId}/documents")
@Tag(name = "4. Document files", description = "Operations for managing user uploaded documents")
public class DocumentController {

    @Autowired
    private DocumentService documentService;
    @Autowired
    private FIRService firService;
    @Autowired
    private UserRepository userRepository;

@RequestMapping(
        path = "/upload",
        method = RequestMethod.POST,
        consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<FileUploadResponse> uploadFile(@RequestPart("file") MultipartFile file) throws FileUploadException {
        FileUploadResponse response = documentService.uploadFile(file, getCurrentUserId());
        return new ResponseEntity<>(response, HttpStatus.OK);
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


}

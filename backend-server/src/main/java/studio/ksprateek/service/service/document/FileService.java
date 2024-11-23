package studio.ksprateek.service.service.document;

import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.springframework.web.multipart.MultipartFile;
import studio.ksprateek.service.payload.responses.FileUploadResponse;

import java.io.IOException;

public interface FileService {
    FileUploadResponse uploadFile(MultipartFile multipartFile, String userID) throws FileUploadException;
    }

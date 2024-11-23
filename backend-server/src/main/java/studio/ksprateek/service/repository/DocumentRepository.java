package studio.ksprateek.service.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.UploadedDocument;

import java.util.List;

@Repository
public interface DocumentRepository extends MongoRepository<UploadedDocument, String> {
    List<UploadedDocument> findByFirId(String firId);
}

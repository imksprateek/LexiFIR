package studio.ksprateek.service.service.document;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.UploadedDocument;
import studio.ksprateek.service.repository.DocumentRepository;

import java.util.List;
import java.util.Optional;

@Service
public class DocumentService {

    @Autowired
    private DocumentRepository documentRepository;

    // Upload a document (Save to S3 and record in database)
    @Transactional
    public UploadedDocument uploadDocument(UploadedDocument document) {
        return documentRepository.save(document);
    }

    // Get all documents for a given FIR
    public List<UploadedDocument> getDocumentsByFIRId(String firId) {
        return documentRepository.findByFirId(firId);
    }

    // Get document by ID
    public Optional<UploadedDocument> getDocumentById(String id) {
        return documentRepository.findById(id);
    }

    // Delete a document
    @Transactional
    public void deleteDocument(String id) {
        documentRepository.deleteById(id);
    }
}

package studio.ksprateek.service.service.legalref;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.LegalReference;
import studio.ksprateek.service.repository.LegalReferenceRepository;

import java.util.List;
import java.util.Optional;

@Service
public class LegalReferenceService {

    @Autowired
    private LegalReferenceRepository legalReferenceRepository;

    // Create a new legal reference
    @Transactional
    public LegalReference addLegalReference(LegalReference legalReference) {
        return legalReferenceRepository.save(legalReference);
    }

    // Get all legal references
    public List<LegalReference> getAllLegalReferences() {
        return legalReferenceRepository.findAll();
    }

    // Get legal reference by ID
    public Optional<LegalReference> getLegalReferenceById(String id) {
        return legalReferenceRepository.findById(id);
    }

    // Update a legal reference
    @Transactional
    public LegalReference updateLegalReference(String id, LegalReference updatedReference) {
        if (legalReferenceRepository.existsById(id)) {
            updatedReference.setId(id);
            return legalReferenceRepository.save(updatedReference);
        }
        throw new RuntimeException("Legal reference not found");
    }

    // Delete a legal reference
    @Transactional
    public void deleteLegalReference(String id) {
        legalReferenceRepository.deleteById(id);
    }
}

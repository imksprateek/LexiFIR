package studio.ksprateek.service.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.LegalReference;

import java.util.List;

@Repository
public interface LegalReferenceRepository extends MongoRepository<LegalReference, String> {
    List<LegalReference> findBySectionCode(String sectionCode);
    List<LegalReference> findByType(String type); // IPC, CrPC, etc.
}


package studio.ksprateek.service.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.FIR;

import java.util.List;

@Repository
public interface FIRRepository extends MongoRepository<FIR, String> {
    List<FIR> findByOfficerId(String officerId);
    List<FIR> findByStatus(String status);
}

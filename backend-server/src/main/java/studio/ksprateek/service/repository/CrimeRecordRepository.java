package studio.ksprateek.service.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.CrimeRecord;

@Repository
public interface CrimeRecordRepository extends MongoRepository<CrimeRecord, String> {
    CrimeRecord findByCaseNumber(String caseNumber);
}

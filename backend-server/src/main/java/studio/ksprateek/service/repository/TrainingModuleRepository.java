package studio.ksprateek.service.repository;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.TrainingModule;

@Repository
public interface TrainingModuleRepository extends MongoRepository<TrainingModule, String> {
}

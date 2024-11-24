package studio.ksprateek.service.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.Questionnaire;

@Repository
public interface QuestionnaireRepository extends MongoRepository<Questionnaire, String> {
}

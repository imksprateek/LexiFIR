package studio.ksprateek.service.service.questionnaire;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.Questionnaire;
import studio.ksprateek.service.repository.QuestionnaireRepository;

import java.util.List;
import java.util.Optional;

@Service
public class QuestionnaireService {

    @Autowired
    private QuestionnaireRepository questionnaireRepository;

    // Create a new questionnaire
    @Transactional
    public Questionnaire createQuestionnaire(Questionnaire questionnaire) {
        return questionnaireRepository.save(questionnaire);
    }

    // Get all questionnaires
    public List<Questionnaire> getAllQuestionnaires() {
        return questionnaireRepository.findAll();
    }

    // Get questionnaire by ID
    public Optional<Questionnaire> getQuestionnaireById(String id) {
        return questionnaireRepository.findById(id);
    }

    // Update a questionnaire
    @Transactional
    public Questionnaire updateQuestionnaire(String id, Questionnaire updatedQuestionnaire) {
        if (questionnaireRepository.existsById(id)) {
            updatedQuestionnaire.setId(id);
            return questionnaireRepository.save(updatedQuestionnaire);
        }
        throw new RuntimeException("Questionnaire not found");
    }

    // Delete a questionnaire
    @Transactional
    public void deleteQuestionnaire(String id) {
        questionnaireRepository.deleteById(id);
    }
}

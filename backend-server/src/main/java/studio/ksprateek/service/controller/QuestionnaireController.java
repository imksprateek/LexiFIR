package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.entity.Questionnaire;
import studio.ksprateek.service.service.questionnaire.QuestionnaireService;

import java.util.List;

@RestController
@RequestMapping("/api/questionnaires")
@Tag(name = "Questionnaires", description = "THIS WILL NOT BE WORKED ON")
public class QuestionnaireController {

    @Autowired
    private QuestionnaireService questionnaireService;

    @GetMapping
    public List<Questionnaire> getAllQuestionnaires() {
        return questionnaireService.getAllQuestionnaires();
    }

    @PostMapping
    public Questionnaire createQuestionnaire(@RequestBody Questionnaire questionnaire) {
        return questionnaireService.createQuestionnaire(questionnaire);
    }

    @PutMapping("/{id}")
    public Questionnaire updateQuestionnaire(@PathVariable String id, @RequestBody Questionnaire questionnaire) {
        return questionnaireService.updateQuestionnaire(id, questionnaire);
    }

    @DeleteMapping("/{id}")
    public void deleteQuestionnaire(@PathVariable String id) {
        questionnaireService.deleteQuestionnaire(id);
    }
}

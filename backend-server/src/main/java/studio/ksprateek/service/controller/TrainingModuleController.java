package studio.ksprateek.service.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import studio.ksprateek.service.entity.TrainingModule;
import studio.ksprateek.service.service.training.TrainingModuleService;

import java.util.List;

@RestController
@RequestMapping("/api/training-modules")
@Tag(name = "5. Training modules", description = "Operations related to Training Modules, Letcures and resources")
public class TrainingModuleController {

    @Autowired
    private TrainingModuleService trainingModuleService;

    @GetMapping
    @Operation(summary = "Get all training modules")
    public List<TrainingModule> getAllModules() {
        return trainingModuleService.getAllTrainingModules();
    }

    @PostMapping
    @Operation(summary = "Add training modules")
    public TrainingModule addTrainingModule(@RequestBody TrainingModule trainingModule) {
        return trainingModuleService.addTrainingModule(trainingModule);
    }

    @DeleteMapping
    @Operation(summary = "Delete a training module")
    public void deleteTrainingModule(@RequestBody TrainingModule trainingModule){
        trainingModuleService.deleteTrainingModule(trainingModule.getId());
    }
}

package studio.ksprateek.service.service.training;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.TrainingModule;
import studio.ksprateek.service.repository.TrainingModuleRepository;

import java.util.List;
import java.util.Optional;

@Service
public class TrainingModuleService {

    @Autowired
    private TrainingModuleRepository trainingModuleRepository;

    // Create a new training module
    @Transactional
    public TrainingModule addTrainingModule(TrainingModule trainingModule) {
        return trainingModuleRepository.save(trainingModule);
    }

    // Get all training modules
    public List<TrainingModule> getAllTrainingModules() {
        return trainingModuleRepository.findAll();
    }

    // Get a training module by ID
    public Optional<TrainingModule> getTrainingModuleById(String id) {
        return trainingModuleRepository.findById(id);
    }

    // Update a training module
    @Transactional
    public TrainingModule updateTrainingModule(String id, TrainingModule updatedTrainingModule) {
        if (trainingModuleRepository.existsById(id)) {
            updatedTrainingModule.setId(id);
            return trainingModuleRepository.save(updatedTrainingModule);
        }
        throw new RuntimeException("Training module not found");
    }

    // Delete a training module
    @Transactional
    public void deleteTrainingModule(String id) {
        trainingModuleRepository.deleteById(id);
    }
}

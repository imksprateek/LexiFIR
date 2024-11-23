package studio.ksprateek.service.service.fir;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.repository.FIRRepository;

import java.util.List;
import java.util.Optional;

@Service
public class FIRService {

    @Autowired
    private FIRRepository firRepository;

    // Create a new FIR (POST request)
    @Transactional
    public FIR createFIR(FIR fir) {
        // Ensure empty fields are set as empty if not provided
        if (fir.getCaseTitle() == null) fir.setCaseTitle("");
        if (fir.getIncidentDescription() == null) fir.setIncidentDescription("");
        if (fir.getStatus() == null) fir.setStatus("");
        fir.setId(null);  // Ensure ID is not passed (generated automatically)
        return firRepository.save(fir);
    }

    // Update an existing FIR (PUT request)
    @Transactional
    public FIR updateFIR(String id, FIR firToUpdate) {
        FIR existingFIR = firRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("FIR not found"));

        // Update only non-empty fields from the request
        if (firToUpdate.getCaseTitle() != null && !firToUpdate.getCaseTitle().isEmpty()) {
            existingFIR.setCaseTitle(firToUpdate.getCaseTitle());
        }
        if (firToUpdate.getIncidentDescription() != null && !firToUpdate.getIncidentDescription().isEmpty()) {
            existingFIR.setIncidentDescription(firToUpdate.getIncidentDescription());
        }
        if (firToUpdate.getIncidentDate() != null) {
            existingFIR.setIncidentDate(firToUpdate.getIncidentDate());
        }
        if (firToUpdate.getLocation() != null) {
            existingFIR.setLocation(firToUpdate.getLocation());
        }
        if (firToUpdate.getRelatedSections() != null) {
            existingFIR.setRelatedSections(firToUpdate.getRelatedSections());
        }
        if (firToUpdate.getLandmarkJudgments() != null) {
            existingFIR.setLandmarkJudgments(firToUpdate.getLandmarkJudgments());
        }
        if (firToUpdate.getStatus() != null && !firToUpdate.getStatus().isEmpty()) {
            existingFIR.setStatus(firToUpdate.getStatus());
        }

        return firRepository.save(existingFIR);
    }

    // Get all FIRs
    public List<FIR> getAllFIRs() {
        return firRepository.findAll();
    }

    // Get FIR by ID
    public Optional<FIR> getFIRById(String id) {
        return firRepository.findById(id);
    }
}

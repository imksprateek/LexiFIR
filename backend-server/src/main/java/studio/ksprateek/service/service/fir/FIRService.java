package studio.ksprateek.service.service.fir;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.repository.FIRRepository;
import studio.ksprateek.service.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class FIRService {

    @Autowired
    private FIRRepository firRepository;
    @Autowired
    private UserRepository userRepository;

    // Create a new FIR (POST request)
    @Transactional
    public FIR createFIR(FIR fir) {
        // Save the FIR entity first
        FIR savedFIR = firRepository.save(fir);

        // Fetch the user (officer) associated with the FIR
        User officer = fir.getOfficerId();  // Assuming the officer is already set in the FIR object

        // Add the new FIR's ID to the user's firIds list
        if (officer.getFirIds() == null) {
            officer.setFirIds(new ArrayList<>());  // Initialize firIds list if it's null
        }
        officer.getFirIds().add(savedFIR.getId());  // Append the new FIR ID

        // Save the updated user
        userRepository.save(officer);

        return savedFIR;  // Return the saved FIR entity
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
    @Transactional
    public void deleteFIR(String id) {
        // Fetch the FIR by ID
        FIR existingFIR = firRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("FIR with ID " + id + " not found"));

        // Perform the deletion
        firRepository.delete(existingFIR);
    }

}

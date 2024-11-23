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

    // Create a new FIR
    @Transactional
    public FIR createFIR(FIR fir) {
        FIR savedFIR = firRepository.save(fir);

        // Add FIR ID to the user's firIds list
        User user = userRepository.findById(fir.getOfficerId().getId())
                .orElseThrow(() -> new RuntimeException("User not found"));
        List<String> firIds = user.getFirIds();
        if (firIds == null) {
            firIds = new ArrayList<>();
        }
        firIds.add(savedFIR.getId());
        user.setFirIds(firIds);
        userRepository.save(user);

        return savedFIR;
    }


    // Get all FIRs
    public List<FIR> getAllFIRs() {
        return firRepository.findAll();
    }

    // Get FIR by ID
    public Optional<FIR> getFIRById(String id) {
        return firRepository.findById(id);
    }

    // Get FIRs by officer ID
    public List<FIR> getFIRsByOfficer(String officerId) {
        return firRepository.findByOfficerId(officerId);
    }

    // Update an FIR
    @Transactional
    public FIR updateFIR(String id, FIR updatedFIR) {
        if (firRepository.existsById(id)) {
            updatedFIR.setId(id);
            return firRepository.save(updatedFIR);
        }
        throw new RuntimeException("FIR not found");
    }

    // Delete an FIR
    @Transactional
    public void deleteFIR(String id) {
        firRepository.deleteById(id);
    }

    public List<FIR> getFIRsByUserId(String userId) {
        return firRepository.findByOfficerId(userId);
    }
}

package studio.ksprateek.service.service.user;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.FIR;
import studio.ksprateek.service.entity.User;
import studio.ksprateek.service.repository.FIRRepository;
import studio.ksprateek.service.repository.UserRepository;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    UserRepository userRepository;
    @Autowired
    FIRRepository firRepository;

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User Not Found with username: " + username));

        return UserDetailsImpl.build(user);
    }

    public boolean emailExists(String email){
        return userRepository.existsByEmail(email);
    }

    public boolean userExists(String username){
        return userRepository.existsByUsername(username);
    }


    public List<FIR> getFIRsByUserId(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        List<String> firIds = user.getFirIds();
        return firIds.stream()
                .map(firId -> firRepository.findById(firId)
                        .orElseThrow(() -> new RuntimeException("FIR not found: " + firId)))
                .collect(Collectors.toList());
    }

    public Optional<User> getUserById(String id) {
        return userRepository.findById(id);
    }

    @Transactional
    public User updateUser(String id, User user) {
        if (userRepository.existsById(id)) {
            user.setId(id);
            return userRepository.save(user);
        }
        throw new RuntimeException("User not found");
    }

    @Transactional
    public void deleteUser(String id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
        } else {
            throw new RuntimeException("User not found");
        }
    }

}
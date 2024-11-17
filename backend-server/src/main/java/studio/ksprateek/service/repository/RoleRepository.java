package studio.ksprateek.service.repository;

import java.util.Optional;
import org.springframework.data.mongodb.repository.MongoRepository;
import studio.ksprateek.service.models.ERole;
import studio.ksprateek.service.models.Role;

public interface RoleRepository extends MongoRepository<Role, String> {
    Optional<Role> findByName(ERole name);
}
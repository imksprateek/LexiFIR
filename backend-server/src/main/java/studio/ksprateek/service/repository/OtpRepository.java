package studio.ksprateek.service.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.Otp;

@Repository
public interface OtpRepository extends MongoRepository<Otp, String> {
    Otp findByEmail(String email);
}

package studio.ksprateek.service.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import studio.ksprateek.service.entity.ChatLog;

@Repository
public interface ChatLogRepository extends MongoRepository<ChatLog, String> {
}

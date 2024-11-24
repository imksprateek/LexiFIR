package studio.ksprateek.service.service.notification;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import studio.ksprateek.service.entity.Notification;
import studio.ksprateek.service.repository.NotificationRepository;

import java.util.List;
import java.util.Optional;

@Service
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    // Create a new notification
    @Transactional
    public Notification createNotification(Notification notification) {
        return notificationRepository.save(notification);
    }

    // Get all notifications for a specific user
    public List<Notification> getNotificationsByUserId(String userId) {
        return notificationRepository.findByUserId(userId);
    }

    // Get notification by ID
    public Optional<Notification> getNotificationById(String id) {
        return notificationRepository.findById(id);
    }

    // Mark notification as read
    @Transactional
    public Notification markNotificationAsRead(String id) {
        Notification notification = notificationRepository.findById(id).orElseThrow(() -> new RuntimeException("Notification not found"));
        notification.setRead(true);
        return notificationRepository.save(notification);
    }

    // Delete a notification
    @Transactional
    public void deleteNotification(String id) {
        notificationRepository.deleteById(id);
    }
}

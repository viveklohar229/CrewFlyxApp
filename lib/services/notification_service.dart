import '../models/notification_model.dart';
import '../mock_data/mock_data.dart';

/// Service for in-app aviation notifications and unread counters.
class NotificationService {
  final List<NotificationModel> _notifications = List.from(MockData.notifications);

  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return List.unmodifiable(_notifications);
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  Future<void> markAllAsRead() async {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}

enum NotificationPriority {
  low,
  medium,
  high,
  critical,
}

enum NotificationType {
  flightSchedule,
  dutyUpdate,
  documentApproval,
  warning,
  announcement,
}

/// Model representing a flight operations or crew alert.
class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final String? actionRoute;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.priority,
    this.isRead = false,
    this.actionRoute,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? timestamp,
    NotificationType? type,
    NotificationPriority? priority,
    bool? isRead,
    String? actionRoute,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
    );
  }
}

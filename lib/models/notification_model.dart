enum NotificationType { dailyLimit, monthlyLimit, approaching, exceeded }

class NotificationModel {
  final String id;
  final String subject;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;
  final bool isStarred;

  NotificationModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
    this.isStarred = false,
  });

  NotificationModel copyWith({bool? isRead, bool? isStarred}) {
    return NotificationModel(
      id: id,
      subject: subject,
      message: message,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
    );
  }
}
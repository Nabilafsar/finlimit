enum NotificationType { dailyLimit, monthlyLimit, approaching, exceeded }

class NotificationModel {
  final String id;
  final String userId;
  final String subject;
  final String message;
  final DateTime createdAt;
  final NotificationType type;
  final bool isRead;
  final bool isStarred;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.type,
    this.isRead = false,
    this.isStarred = false,
  });

  NotificationModel copyWith({bool? isRead, bool? isStarred}) {
    return NotificationModel(
      id: id,
      userId: userId,
      subject: subject,
      message: message,
      createdAt: createdAt,
      type: type,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'subject': subject,
      'message': message,
      'time': createdAt.toIso8601String(),
      'type': type.name,
      'is_read': isRead ? 1 : 0,
      'is_starred': isStarred ? 1 : 0,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      subject: map['subject'] ?? '',
      message: map['message'] ?? '',
      createdAt: DateTime.tryParse(map['time'] ?? '') ?? DateTime.now(),
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.exceeded,
      ),
      isRead: (map['is_read'] ?? 0) == 1,
      isStarred: (map['is_starred'] ?? 0) == 1,
    );
  }

  String get formattedTime {
    final now = DateTime.now();
    final isToday = createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;

    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');

    if (isToday) return '$hour.$minute';

    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${createdAt.day} ${months[createdAt.month]}';
  }
}
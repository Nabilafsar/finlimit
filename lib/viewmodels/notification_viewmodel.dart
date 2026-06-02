import 'package:flutter/material.dart';
import '../models/notification_model.dart';

enum NotificationFilter { all, unread, starred }

class NotificationViewModel extends ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1', subject: 'Daily Limit Reached',
      message: 'Pengeluaran harian kamu sudah mencapai 100% dari limit Rp150.000.',
      time: '13.29', type: NotificationType.exceeded, isRead: false,
    ),
    NotificationModel(
      id: '2', subject: 'Approaching Daily Limit',
      message: 'Kamu sudah menggunakan 80% dari limit harian. Sisa Rp30.000.',
      time: '12.43', type: NotificationType.approaching, isRead: false,
    ),
    NotificationModel(
      id: '3', subject: 'Monthly Limit Warning',
      message: 'Pengeluaran bulanan kamu telah mencapai 90% dari limit Rp3.000.000.',
      time: '09.38', type: NotificationType.monthlyLimit, isRead: false,
    ),
    NotificationModel(
      id: '4', subject: 'Daily Limit Reset',
      message: 'Limit harian kamu telah direset. Limit baru: Rp150.000.',
      time: '07.19', type: NotificationType.dailyLimit, isRead: false,
    ),
    NotificationModel(
      id: '5', subject: 'Approaching Monthly Limit',
      message: 'Kamu sudah menggunakan 75% dari limit bulanan bulan ini.',
      time: '03.01', type: NotificationType.approaching, isRead: true,
    ),
    NotificationModel(
      id: '6', subject: 'Daily Limit Reached',
      message: 'Pengeluaran harian kamu sudah mencapai 100% dari limit Rp150.000.',
      time: '11 Apr', type: NotificationType.exceeded, isRead: true,
    ),
    NotificationModel(
      id: '7', subject: 'Monthly Limit Exceeded',
      message: 'Pengeluaran bulanan kamu telah melebihi limit yang ditentukan.',
      time: '9 Apr', type: NotificationType.exceeded, isRead: true,
    ),
    NotificationModel(
      id: '8', subject: 'Approaching Daily Limit',
      message: 'Sisa limit harian kamu tinggal Rp20.000. Hemat pengeluaranmu.',
      time: '5 Apr', type: NotificationType.approaching, isRead: true,
    ),
    NotificationModel(
      id: '9', subject: 'Monthly Limit Set',
      message: 'Limit pengeluaran bulanan berhasil diatur ke Rp3.000.000.',
      time: '30 Mar', type: NotificationType.monthlyLimit, isRead: true,
    ),
    NotificationModel(
      id: '10', subject: 'Daily Limit Updated',
      message: 'Limit pengeluaran harian berhasil diubah menjadi Rp150.000.',
      time: '27 Mar', type: NotificationType.dailyLimit, isRead: true,
    ),
    NotificationModel(
      id: '11', subject: 'Approaching Monthly Limit',
      message: 'Pengeluaran bulan ini sudah mencapai 60% dari limit bulanan.',
      time: '23 Mar', type: NotificationType.approaching, isRead: true,
    ),
  ];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  void toggleStar(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(
        isStarred: !_notifications[index].isStarred,
      );
      notifyListeners();
    }
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  Color typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.exceeded:    return const Color(0xFFDC2626);
      case NotificationType.approaching: return const Color(0xFF2563EB);
      case NotificationType.monthlyLimit: return const Color(0xFF7C3AED);
      case NotificationType.dailyLimit:  return const Color(0xFF16A34A);
    }
  }

  NotificationFilter _activeFilter = NotificationFilter.all;
  NotificationFilter get activeFilter => _activeFilter;

  String get filterLabel {
    switch (_activeFilter) {
      case NotificationFilter.all:    return 'All';
      case NotificationFilter.unread: return 'Unread';
      case NotificationFilter.starred: return 'Starred';
    }
  }

  List<NotificationModel> get filteredNotifications {
    switch (_activeFilter) {
      case NotificationFilter.all:
        return List.unmodifiable(_notifications);
      case NotificationFilter.unread:
        return _notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.starred:
        return _notifications.where((n) => n.isStarred).toList();
    }
  }

  void setFilter(NotificationFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }
}

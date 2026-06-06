import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../data/db/db_helper.dart';
import '../models/notification_model.dart';

enum NotificationFilter { all, unread, starred }

class NotificationViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<NotificationModel> _notifications = [];

  NotificationFilter _activeFilter = NotificationFilter.all;
  NotificationFilter get activeFilter => _activeFilter;

  String get filterLabel {
    switch (_activeFilter) {
      case NotificationFilter.all:     return 'All';
      case NotificationFilter.unread:  return 'Unread';
      case NotificationFilter.starred: return 'Starred';
    }
  }

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

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

  // Load notifikasi dari DB
  Future<void> loadNotifications(String userId) async {
    if (userId.isEmpty) return;
    isLoading = true;
    notifyListeners();

    try {
      final raw = await DbHelper.getNotificationsByUser(userId);
      _notifications = raw
          .map((e) => NotificationModel.fromMap(e))
          .toList();
    } catch (e) {
      debugPrint('NotificationViewModel error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Tambah notifikasi baru ke DB dan list
  Future<void> addNotification(NotificationModel notif) async {
    try {
      await DbHelper.insertNotification(notif.toMap());
      _notifications.insert(0, notif);
      notifyListeners();
    } catch (e) {
      debugPrint('addNotification error: $e');
    }
  }

  // Cek limit dan otomatis buat notifikasi jika perlu
  Future<void> checkAndNotify({
    required String userId,
    required double todaySpending,
    required double dailyLimit,
  }) async {
    if (dailyLimit <= 0) return;

    final percent = todaySpending / dailyLimit;

    if (percent >= 1.0) {
      final notif = NotificationModel(
        id: const Uuid().v4(),
        userId: userId,
        subject: 'Daily Limit Exceeded',
        message:
            'Pengeluaran harian kamu sudah melebihi limit harian. Harap kendalikan pengeluaranmu!',
        createdAt: DateTime.now(),
        type: NotificationType.exceeded,
      );
      await addNotification(notif);
    } else if (percent >= 0.75) {
      final sisa = dailyLimit - todaySpending;
      final notif = NotificationModel(
        id: const Uuid().v4(),
        userId: userId,
        subject: 'Approaching Daily Limit',
        message:
            'Kamu sudah menggunakan ${(percent * 100).toInt()}% dari limit harian. Sisa Rp${_fmt(sisa)}.',
        createdAt: DateTime.now(),
        type: NotificationType.approaching,
      );
      await addNotification(notif);
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await DbHelper.markNotificationAsRead(id);
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] =
            _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('markAsRead error: $e');
    }
  }

  Future<void> toggleStar(String id) async {
    try {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final newStarred = !_notifications[index].isStarred;
        await DbHelper.toggleStarNotification(id, newStarred);
        _notifications[index] =
            _notifications[index].copyWith(isStarred: newStarred);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('toggleStar error: $e');
    }
  }

  void setFilter(NotificationFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  Color typeColor(NotificationType type) {
    switch (type) {
      case NotificationType.exceeded:     return const Color(0xFFDC2626);
      case NotificationType.approaching:  return const Color(0xFF2563EB);
      case NotificationType.monthlyLimit: return const Color(0xFF7C3AED);
      case NotificationType.dailyLimit:   return const Color(0xFF16A34A);
    }
  }

  String _fmt(double amount) {
    final str = amount.abs().toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}
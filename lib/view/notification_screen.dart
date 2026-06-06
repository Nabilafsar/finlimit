import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
          context.read<AuthViewModel>().currentUser?.id ?? '';
      context.read<NotificationViewModel>().loadNotifications(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _NotificationContent();
  }
}

class _NotificationContent extends StatelessWidget {
  const _NotificationContent();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFE8ECF4),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppBar(),
              const SizedBox(height: 16),
              _FilterHeader(),
              const SizedBox(height: 12),
              const Expanded(child: _NotificationList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(
              Icons.arrow_back,
              size: 26,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            vm.filterLabel,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F172A),
            ),
          ),
          _FilterDropdown(),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    return PopupMenuButton<NotificationFilter>(
      onSelected: (filter) => vm.setFilter(filter),
      icon: const Icon(
        Icons.filter_alt_outlined,
        size: 24,
        color: Color(0xFF0F172A),
      ),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      itemBuilder: (_) => [
        _buildMenuItem(
          filter: NotificationFilter.all,
          label: 'All',
          icon: Icons.notifications_rounded,
          isActive: vm.activeFilter == NotificationFilter.all,
        ),
        _buildMenuItem(
          filter: NotificationFilter.unread,
          label: 'Unread',
          icon: Icons.mark_email_unread_rounded,
          isActive: vm.activeFilter == NotificationFilter.unread,
        ),
        _buildMenuItem(
          filter: NotificationFilter.starred,
          label: 'Starred',
          icon: Icons.star_rounded,
          isActive: vm.activeFilter == NotificationFilter.starred,
        ),
      ],
    );
  }

  PopupMenuItem<NotificationFilter> _buildMenuItem({
    required NotificationFilter filter,
    required String label,
    required IconData icon,
    required bool isActive,
  }) {
    return PopupMenuItem(
      value: filter,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isActive
                ? const Color(0xFF2563EB)
                : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  const _NotificationList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();

    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2563EB)),
      );
    }

    final notifs = vm.filteredNotifications;

    if (notifs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_off_outlined,
                size: 52, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Belum ada notifikasi',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: notifs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notif = notifs[index];
        return _NotificationTile(notification: notif);
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<NotificationViewModel>();
    final color = vm.typeColor(notification.type);

    return GestureDetector(
      onTap: () => vm.markAsRead(notification.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon type
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _typeIcon(notification.type),
                size: 26,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.subject,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead
                          ? FontWeight.w600
                          : FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Time + Star + Unread dot
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(
                      notification.formattedTime,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () => vm.toggleStar(notification.id),
                  child: Icon(
                    notification.isStarred
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 20,
                    color: notification.isStarred
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.exceeded:
        return Icons.warning_rounded;
      case NotificationType.approaching:
        return Icons.notifications_active_rounded;
      case NotificationType.monthlyLimit:
        return Icons.calendar_month_rounded;
      case NotificationType.dailyLimit:
        return Icons.today_rounded;
    }
  }
}
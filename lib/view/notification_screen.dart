import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(),
      child: const _NotificationContent(),
    );
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            color: isActive ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? const Color(0xFF2563EB) : const Color(0xFF0F172A),
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

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: vm.filteredNotifications.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final notif = vm.filteredNotifications[index];
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 30,
                color: Color(0xFFCBD5E1),
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
                    maxLines: 1,
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
                      notification.time,
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
                          color: vm.typeColor(notification.type),
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
}
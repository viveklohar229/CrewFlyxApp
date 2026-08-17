import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/notification_model.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/empty_state_view.dart';

/// Notifications screen displaying operational alerts, schedules, and document approvals.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _mapNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.flightSchedule:
        return Icons.flight_takeoff;
      case NotificationType.dutyUpdate:
        return Icons.event_available;
      case NotificationType.documentApproval:
        return Icons.assignment_turned_in;
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.announcement:
        return Icons.campaign_outlined;
    }
  }

  Color _mapNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.flightSchedule:
        return AppColors.primarySky;
      case NotificationType.dutyUpdate:
        return AppColors.cyanAccent;
      case NotificationType.documentApproval:
        return AppColors.runwayGold;
      case NotificationType.warning:
        return AppColors.emergencyRed;
      case NotificationType.announcement:
        return AppColors.infoBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifications = state.notifications;

    return Scaffold(
      appBar: AviationAppBar(
        title: 'Operations Alerts',
      ),
      drawer: const AviationDrawer(activeIndex: 6),
      body: Column(
        children: [
          // Top Action Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.aeroNavyMedium.withValues(alpha: 0.4) : AppColors.surfaceLight,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${state.unreadNotificationCount} Unread Notifications',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.aeroNavy,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.done_all, size: 16, color: AppColors.primarySky),
                  label: const Text(
                    'Mark all as read',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primarySky,
                    ),
                  ),
                  onPressed: () {
                    state.markAllNotificationsRead();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All notifications marked as read.'),
                        backgroundColor: AppColors.primarySky,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: notifications.isEmpty
                ? const EmptyStateView(
                    title: 'No Notifications',
                    message: 'You are all caught up with flight operations.',
                    icon: Icons.notifications_off_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      final iconColor = _mapNotificationColor(notif.type);

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            state.markNotificationRead(notif.id);
                            if (notif.actionRoute != null) {
                              Navigator.of(context).pushNamed(notif.actionRoute!);
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? (notif.isRead ? AppColors.cardDark : AppColors.aeroNavyMedium)
                                  : (notif.isRead ? AppColors.cardLight : const Color(0xFFF0F9FF)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: notif.isRead
                                    ? (isDark ? AppColors.borderDark : AppColors.borderLight)
                                    : AppColors.primarySkyLight.withValues(alpha: 0.5),
                                width: notif.isRead ? 1.0 : 1.5,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon Circle
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: iconColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _mapNotificationIcon(notif.type),
                                    size: 20,
                                    color: iconColor,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              notif.title,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                                                color: isDark ? Colors.white : AppColors.aeroNavy,
                                              ),
                                            ),
                                          ),
                                          if (!notif.isRead)
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: AppColors.primarySky,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        notif.description,
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.35,
                                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        DateFormatter.timeAgo(notif.timestamp),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: isDark ? AppColors.textMuted : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

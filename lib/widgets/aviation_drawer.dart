import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../state/app_state_provider.dart';
import 'aviation_logo.dart';

/// Full-featured Aviation Navigation Drawer for Crew Flyx.
class AviationDrawer extends StatelessWidget {
  final int activeIndex;

  const AviationDrawer({
    super.key,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = AppStateScope.of(context);
    final user = state.currentUser;

    return Drawer(
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Top Section: Crew Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.aeroGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.aeroNavy.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AviationLogo(size: 40, isDark: true),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          user?.companyCode ?? 'SKY-AERO',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.fullName ?? 'Capt. Alexander Hayes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user?.designation ?? 'Senior Commander (A320)',
                    style: const TextStyle(
                      color: AppColors.primarySkyLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.companyName ?? 'SkyWings Aero International',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Items List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                children: [
                  _DrawerItem(
                    index: 0,
                    title: AppStrings.menuDashboard,
                    icon: Icons.dashboard_outlined,
                    isActive: activeIndex == 0,
                    onTap: () => _navigate(context, 0, '/dashboard'),
                  ),
                  _DrawerItem(
                    index: 1,
                    title: AppStrings.menuCrew,
                    icon: Icons.badge_outlined,
                    isActive: activeIndex == 1,
                    onTap: () => _navigate(context, 1, '/crew'),
                  ),
                  _DrawerItem(
                    index: 2,
                    title: AppStrings.menuFlightSchedule,
                    icon: Icons.flight_takeoff_outlined,
                    isActive: activeIndex == 2,
                    onTap: () => _navigate(context, 2, '/flight_schedule'),
                  ),
                  _DrawerItem(
                    index: 3,
                    title: AppStrings.menuDutySchedule,
                    icon: Icons.calendar_month_outlined,
                    isActive: activeIndex == 3,
                    onTap: () => _navigate(context, 3, '/duty_schedule'),
                  ),
                  _DrawerItem(
                    index: 4,
                    title: AppStrings.menuDocuments,
                    icon: Icons.folder_open_outlined,
                    isActive: activeIndex == 4,
                    onTap: () => _navigate(context, 4, '/documents'),
                  ),
                  _DrawerItem(
                    index: 5,
                    title: AppStrings.menuWarningsViolations,
                    icon: Icons.warning_amber_rounded,
                    isActive: activeIndex == 5,
                    onTap: () => _navigate(context, 5, '/warnings_violations'),
                  ),
                  _DrawerItem(
                    index: 6,
                    title: AppStrings.menuNotifications,
                    icon: Icons.notifications_outlined,
                    badgeCount: state.unreadNotificationCount,
                    isActive: activeIndex == 6,
                    onTap: () => _navigate(context, 6, '/notifications'),
                  ),
                  _DrawerItem(
                    index: 7,
                    title: AppStrings.menuReports,
                    icon: Icons.assessment_outlined,
                    isActive: activeIndex == 7,
                    onTap: () => _navigate(context, 7, '/reports'),
                  ),
                  _DrawerItem(
                    index: 8,
                    title: AppStrings.menuProfile,
                    icon: Icons.person_outline,
                    isActive: activeIndex == 8,
                    onTap: () => _navigate(context, 8, '/profile'),
                  ),
                ],
              ),
            ),

            // Bottom Section: Settings & Logout
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  _DrawerItem(
                    index: 9,
                    title: AppStrings.menuSettings,
                    icon: Icons.settings_outlined,
                    isActive: activeIndex == 9,
                    onTap: () => _navigate(context, 9, '/settings'),
                  ),
                  _DrawerItem(
                    index: 10,
                    title: AppStrings.menuLogout,
                    icon: Icons.logout_rounded,
                    iconColor: AppColors.emergencyRed,
                    textColor: AppColors.emergencyRed,
                    isActive: false,
                    onTap: () => _confirmLogout(context, state),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, int index, String routeName) {
    Navigator.of(context).pop(); // Close drawer
    final state = AppStateScope.of(context);
    state.setSelectedDrawerIndex(index);

    if (ModalRoute.of(context)?.settings.name != routeName) {
      if (routeName == '/dashboard') {
        Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => false);
      } else {
        Navigator.of(context).pushNamed(routeName);
      }
    }
  }

  void _confirmLogout(BuildContext context, AppState state) {
    Navigator.of(context).pop(); // Close drawer
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: AppColors.emergencyRed),
            SizedBox(width: 10),
            Text(AppStrings.logoutConfirmTitle),
          ],
        ),
        content: const Text(AppStrings.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(dialogCtx).pop();
              await state.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            },
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final int? badgeCount;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.index,
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.badgeCount,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? AppColors.primarySkyDark.withValues(alpha: 0.35) : AppColors.skyBackground)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isActive
            ? Border.all(color: AppColors.primarySky.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        leading: Icon(
          icon,
          size: 22,
          color: isActive
              ? AppColors.primarySky
              : (iconColor ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? (isDark ? Colors.white : AppColors.primarySkyDark)
                : (textColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)),
          ),
        ),
        trailing: (badgeCount != null && badgeCount! > 0)
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.emergencyRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

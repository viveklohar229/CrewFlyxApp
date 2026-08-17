import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/aviation_logo.dart';

/// Settings screen for preferences, dark mode toggle, notifications, and app info.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _flightRosterAlerts = true;
  bool _fdtlComplianceAlerts = true;
  String _selectedLanguage = 'English (US - ICAO)';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = state.isDarkMode;

    return Scaffold(
      appBar: const AviationAppBar(
        title: 'Settings & Preferences',
      ),
      drawer: const AviationDrawer(activeIndex: 9),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section: Appearance
          _SectionHeader(title: 'Appearance'),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1.2,
              ),
            ),
            child: SwitchListTile(
              secondary: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: AppColors.primarySky,
              ),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                isDark ? 'Cockpit night mode active' : 'Day mode active',
                style: const TextStyle(fontSize: 12),
              ),
              value: isDark,
              activeColor: AppColors.primarySky,
              onChanged: (val) => state.toggleTheme(),
            ),
          ),

          const SizedBox(height: 20),

          // Section: Notifications
          _SectionHeader(title: 'Notification Preferences'),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active, color: AppColors.primarySky),
                  title: const Text('Push Notifications', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  value: _pushNotifications,
                  activeColor: AppColors.primarySky,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.flight_takeoff, color: AppColors.cyanAccent),
                  title: const Text('Flight Roster Updates', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  value: _flightRosterAlerts,
                  activeColor: AppColors.primarySky,
                  onChanged: (val) => setState(() => _flightRosterAlerts = val),
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.warning_amber, color: AppColors.runwayGold),
                  title: const Text('FDTL & Safety Notices', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  value: _fdtlComplianceAlerts,
                  activeColor: AppColors.primarySky,
                  onChanged: (val) => setState(() => _fdtlComplianceAlerts = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Language & Security
          _SectionHeader(title: 'Localization & Security'),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.primarySky),
                  title: const Text('Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: Text(_selectedLanguage, style: const TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showLanguageDialog(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock_reset, color: AppColors.primarySky),
                  title: const Text('Change Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Update aviation portal credentials', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showChangePasswordDialog(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: About & System Info
          _SectionHeader(title: 'About System'),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1.2,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.primarySky),
                  title: const Text('About Crew Flyx', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Commercial Crew Management Suite', style: TextStyle(fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.verified, color: AppColors.primarySky),
                  title: const Text('Application Version', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text(AppStrings.appVersion, style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Select Aviation Language'),
        children: [
          'English (US - ICAO)',
          'English (UK)',
          'Français (OACI)',
          'Español (Aeronáutico)',
          'Deutsch (Flugbetrieb)',
        ].map((lang) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _selectedLanguage = lang);
              Navigator.of(ctx).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(lang, style: const TextStyle(fontSize: 14)),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySky,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully!'),
                  backgroundColor: AppColors.successGreen,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            AviationLogo(size: 36),
            SizedBox(width: 10),
            Text('Crew Flyx'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crew Management & Flight Operations',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            SizedBox(height: 8),
            Text(
              'Crew Flyx provides end-to-end commercial aviation roster management, FDTL regulatory compliance tracking, e-Logbook recording, and real-time operations alerts.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              'Engineered with Flutter & Material 3 design.',
              style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.primarySky,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

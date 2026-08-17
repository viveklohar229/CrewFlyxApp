import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/warning_violation_model.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/warning_violation_card.dart';
import '../../widgets/empty_state_view.dart';

/// Warnings and Violations compliance monitoring screen.
class WarningsViolationsScreen extends StatefulWidget {
  const WarningsViolationsScreen({super.key});

  @override
  State<WarningsViolationsScreen> createState() => _WarningsViolationsScreenState();
}

class _WarningsViolationsScreenState extends State<WarningsViolationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final warnings = state.warningsViolations.where((e) => !e.isViolation).toList();
    final violations = state.warningsViolations.where((e) => e.isViolation).toList();

    return Scaffold(
      appBar: const AviationAppBar(
        title: 'Warnings & Violations',
      ),
      drawer: const AviationDrawer(activeIndex: 5),
      body: Column(
        children: [
          // Tab Header Bar
          Container(
            color: isDark ? AppColors.aeroNavyMedium.withValues(alpha: 0.5) : AppColors.surfaceLight,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primarySky,
              unselectedLabelColor: isDark ? AppColors.textMuted : AppColors.textSecondary,
              indicatorColor: AppColors.primarySky,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.warningOrange),
                      const SizedBox(width: 8),
                      Text('Safety Warnings (${warnings.length})'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 18, color: AppColors.emergencyRed),
                      const SizedBox(width: 8),
                      Text('Violations (${violations.length})'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Warnings List
                warnings.isEmpty
                    ? const EmptyStateView(
                        title: 'No Active Warnings',
                        message: 'Great job! You have no safety warnings logged.',
                        icon: Icons.check_circle_outline,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: warnings.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = warnings[index];
                          return WarningViolationCard(
                            item: item,
                            onAcknowledge: () {
                              state.acknowledgeWarningOrViolation(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Warning notice acknowledged and logged.'),
                                  backgroundColor: AppColors.successGreen,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        },
                      ),

                // Violations List
                violations.isEmpty
                    ? const EmptyStateView(
                        title: 'Zero Violations',
                        message: 'Clean compliance record! No SOP violations reported.',
                        icon: Icons.verified_outlined,
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: violations.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = violations[index];
                          return WarningViolationCard(
                            item: item,
                            onAcknowledge: () {
                              state.acknowledgeWarningOrViolation(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Violation response acknowledged.'),
                                  backgroundColor: AppColors.successGreen,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

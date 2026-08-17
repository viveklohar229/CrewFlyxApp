import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';

/// Reports screen showing Flight Hours Summary, FDTL compliance logs, and export actions.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AviationAppBar(
        title: 'Flight & Duty Reports',
      ),
      drawer: const AviationDrawer(activeIndex: 7),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.aeroGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.analytics, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Operations Logbook',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Official DGCA e-Logbook & Duty Compliance Export',
                        style: TextStyle(
                          color: AppColors.primarySkyLight,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Available Reports',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),

          _ReportCard(
            title: 'FDTL Monthly Compliance Report',
            description: 'Cumulative flight time, rest periods, and night duty hours for August 2026.',
            date: 'Generated: 17 Aug 2026',
            fileSize: '1.8 MB PDF',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _ReportCard(
            title: 'Pilot Electronic Logbook (e-Logbook)',
            description: 'Instrument flying hours, night landings, PIC time, and sector routes.',
            date: 'Updated: 16 Aug 2026',
            fileSize: '3.4 MB PDF',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _ReportCard(
            title: 'Sector Layover & Per Diem Statement',
            description: 'International & domestic hotel layover logs with allowance disbursement summary.',
            date: 'Updated: 15 Aug 2026',
            fileSize: '950 KB PDF',
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          _ReportCard(
            title: 'Simulator Proficiency & PPC Evaluation',
            description: 'Recurrent simulator check grades, CAT-III ILS approaches, and instructor remarks.',
            date: 'Generated: 10 Jul 2026',
            fileSize: '2.1 MB PDF',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String fileSize;
  final bool isDark;

  const _ReportCard({
    required this.title,
    required this.description,
    required this.date,
    required this.fileSize,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: AppColors.primarySky, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.aeroNavy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$date • $fileSize',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarySky,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.download, size: 14),
                label: const Text('Export PDF', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Exporting $title...'),
                      backgroundColor: AppColors.primarySky,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

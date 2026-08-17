import 'package:flutter/material.dart';
import '../models/warning_violation_model.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import 'status_badge.dart';

/// Warning and Violation card with severity status, description, and acknowledgment action.
class WarningViolationCard extends StatelessWidget {
  final WarningViolationModel item;
  final VoidCallback? onAcknowledge;

  const WarningViolationCard({
    super.key,
    required this.item,
    this.onAcknowledge,
  });

  BadgeType _mapSeverityBadge(SeverityLevel severity) {
    switch (severity) {
      case SeverityLevel.minor:
        return BadgeType.warning;
      case SeverityLevel.moderate:
        return BadgeType.delayed;
      case SeverityLevel.severe:
        return BadgeType.violation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isViolation = item.isViolation;
    final accentColor = isViolation ? AppColors.emergencyRed : AppColors.warningOrange;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.12 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isViolation ? Icons.error_outline : Icons.warning_amber_rounded,
                      size: 18,
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isViolation ? 'VIOLATION NOTICE' : 'SAFETY WARNING',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                StatusBadge(
                  text: item.severityDisplay,
                  type: _mapSeverityBadge(item.severity),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.aeroNavy,
                        ),
                      ),
                    ),
                    Text(
                      DateFormatter.formatShortDate(item.date),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Category: ${item.type} • Ref: ${item.flightNumber}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primarySky,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                if (item.resolutionNotes != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.aeroNavyMedium.withValues(alpha: 0.4)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 14, color: AppColors.primarySky),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Action: ${item.resolutionNotes!}',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 8),

                // Footer: Status and Acknowledge Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status: ${item.statusDisplay}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: item.status == IssueStatus.acknowledged
                            ? AppColors.successGreen
                            : AppColors.warningOrange,
                      ),
                    ),
                    if (item.status != IssueStatus.acknowledged)
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
                        onPressed: onAcknowledge,
                        icon: const Icon(Icons.check, size: 14),
                        label: const Text(
                          'Acknowledge',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      )
                    else
                      const Row(
                        children: [
                          Icon(Icons.done_all, size: 14, color: AppColors.successGreen),
                          SizedBox(width: 4),
                          Text(
                            'Acknowledged',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

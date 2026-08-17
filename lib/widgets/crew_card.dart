import 'package:flutter/material.dart';
import '../models/crew_model.dart';
import '../core/constants/app_colors.dart';
import 'status_badge.dart';

/// Crew member card with designation, base, status, and communication shortcuts.
class CrewCard extends StatelessWidget {
  final CrewModel crew;
  final VoidCallback? onTap;

  const CrewCard({
    super.key,
    required this.crew,
    this.onTap,
  });

  BadgeType _mapStatusToBadge(CrewStatus status) {
    switch (status) {
      case CrewStatus.onDuty:
        return BadgeType.active;
      case CrewStatus.scheduled:
        return BadgeType.scheduled;
      case CrewStatus.standby:
        return BadgeType.standby;
      case CrewStatus.rest:
        return BadgeType.rest;
      case CrewStatus.leave:
        return BadgeType.leave;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primarySky.withValues(alpha: 0.15),
                child: Text(
                  crew.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primarySky,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Crew Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            crew.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.aeroNavy,
                            ),
                          ),
                        ),
                        StatusBadge(
                          text: crew.statusDisplay,
                          type: _mapStatusToBadge(crew.status),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      crew.designationDisplay,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primarySky,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'ID: ${crew.employeeId}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• Base: ${crew.baseAirport}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${crew.totalHours} hrs',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.aeroNavy,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Assigned: ${crew.assignedFlight}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textMuted : AppColors.textSecondary,
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
  }
}

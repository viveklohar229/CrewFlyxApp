import 'package:flutter/material.dart';
import '../models/duty_model.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import 'status_badge.dart';

/// Duty overview card with reporting time, duty hours, and check-in action.
class DutyCard extends StatelessWidget {
  final DutyModel duty;
  final VoidCallback? onCheckIn;
  final VoidCallback? onTap;

  const DutyCard({
    super.key,
    required this.duty,
    this.onCheckIn,
    this.onTap,
  });

  BadgeType _mapDutyTypeBadge(DutyType type) {
    switch (type) {
      case DutyType.flightDuty:
        return BadgeType.onTime;
      case DutyType.standby:
        return BadgeType.standby;
      case DutyType.simulator:
        return BadgeType.scheduled;
      case DutyType.restPeriod:
        return BadgeType.rest;
      case DutyType.groundTraining:
      case DutyType.medicalCheck:
        return BadgeType.info;
    }
  }

  IconData _mapDutyTypeIcon(DutyType type) {
    switch (type) {
      case DutyType.flightDuty:
        return Icons.flight_takeoff;
      case DutyType.standby:
        return Icons.access_alarm;
      case DutyType.simulator:
        return Icons.flight_class;
      case DutyType.restPeriod:
        return Icons.hotel;
      case DutyType.groundTraining:
        return Icons.school;
      case DutyType.medicalCheck:
        return Icons.medical_services;
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
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Duty Type Badge + Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primarySky.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _mapDutyTypeIcon(duty.dutyType),
                            size: 16,
                            color: AppColors.primarySky,
                          ),
                        ),
                        const SizedBox(width: 8),
                        StatusBadge(
                          text: duty.typeDisplay,
                          type: _mapDutyTypeBadge(duty.dutyType),
                        ),
                      ],
                    ),
                    Text(
                      DateFormatter.formatDayDate(duty.dutyDate),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.aeroNavy,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Duty Details Grid
                Row(
                  children: [
                    Expanded(
                      child: _DutyTimeBox(
                        label: 'Reporting Time',
                        time: DateFormatter.formatTime(duty.reportingTime),
                        isDark: isDark,
                        icon: Icons.login,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DutyTimeBox(
                        label: 'Release Time',
                        time: DateFormatter.formatTime(duty.releaseTime),
                        isDark: isDark,
                        icon: Icons.logout,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Location & Pairing Info
                if (duty.flightNumber != null) ...[
                  Row(
                    children: [
                      const Icon(Icons.confirmation_number_outlined, size: 14, color: AppColors.primarySky),
                      const SizedBox(width: 6),
                      Text(
                        'Flight: ${duty.flightNumber}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primarySkyDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],

                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        duty.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 8),

                // Footer: FDTL Duty Hours & Check-In Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Duty: ${duty.dutyHours}h',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.aeroNavy,
                          ),
                        ),
                        if (duty.blockHours > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            '• Block: ${duty.blockHours}h',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (duty.dutyType != DutyType.restPeriod)
                      duty.isCheckedIn
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.successGreen.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, size: 14, color: AppColors.successGreen),
                                  SizedBox(width: 4),
                                  Text(
                                    'Checked In',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.successGreen,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primarySky,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(0, 32),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: onCheckIn,
                              icon: const Icon(Icons.qr_code_scanner, size: 14),
                              label: const Text(
                                'Check In',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DutyTimeBox extends StatelessWidget {
  final String label;
  final String time;
  final bool isDark;
  final IconData icon;

  const _DutyTimeBox({
    required this.label,
    required this.time,
    required this.isDark,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.aeroNavyMedium.withValues(alpha: 0.5) : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.primarySky),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.aeroNavy,
            ),
          ),
        ],
      ),
    );
  }
}

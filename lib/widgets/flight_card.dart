import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/date_formatter.dart';
import 'status_badge.dart';

/// Flight card displaying departure, arrival, aircraft, timings, and status.
class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onTap;

  const FlightCard({
    super.key,
    required this.flight,
    this.onTap,
  });

  BadgeType _mapStatusToBadge(FlightStatus status) {
    switch (status) {
      case FlightStatus.scheduled:
        return BadgeType.scheduled;
      case FlightStatus.boarding:
        return BadgeType.boarding;
      case FlightStatus.departed:
        return BadgeType.departed;
      case FlightStatus.onTime:
        return BadgeType.onTime;
      case FlightStatus.delayed:
        return BadgeType.delayed;
      case FlightStatus.arrived:
        return BadgeType.arrived;
      case FlightStatus.cancelled:
        return BadgeType.cancelled;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Top Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.aeroNavyMedium.withValues(alpha: 0.5)
                      : AppColors.surfaceLight,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.flight_takeoff, size: 16, color: AppColors.primarySky),
                        const SizedBox(width: 6),
                        Text(
                          flight.flightNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: AppColors.primarySky,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${flight.duration}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    StatusBadge(
                      text: flight.statusDisplay,
                      type: _mapStatusToBadge(flight.status),
                    ),
                  ],
                ),
              ),

              // Route & Timings Body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Departure
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.departureAirport,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                  color: isDark ? Colors.white : AppColors.aeroNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormatter.formatTime(flight.departureTime),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primarySky,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                flight.departureCity,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Animated Flight Path Graphic
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.flight,
                                size: 20,
                                color: AppColors.primarySky,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primarySky,
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 1.5,
                                    color: AppColors.primarySkyLight,
                                  ),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark ? Colors.white : AppColors.aeroNavy,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Arrival
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                flight.arrivalAirport,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                  color: isDark ? Colors.white : AppColors.aeroNavy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormatter.formatTime(flight.arrivalTime),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primarySky,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                flight.arrivalCity,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Aircraft, Terminal & Crew Status Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.airplanemode_active,
                                size: 14,
                                color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  flight.aircraft,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.skyBackground.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            flight.crewStatus,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primarySkyDark,
                            ),
                          ),
                        ),
                      ],
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

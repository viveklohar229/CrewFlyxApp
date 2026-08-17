import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/duty_model.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/duty_card.dart';

/// Duty Schedule screen with FDTL hours tracking and roster list.
class DutyScheduleScreen extends StatefulWidget {
  const DutyScheduleScreen({super.key});

  @override
  State<DutyScheduleScreen> createState() => _DutyScheduleScreenState();
}

class _DutyScheduleScreenState extends State<DutyScheduleScreen> {
  DutyType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredDuties = state.duties.where((duty) {
      if (_selectedType == null) return true;
      return duty.dutyType == _selectedType;
    }).toList();

    return Scaffold(
      appBar: const AviationAppBar(
        title: 'Duty Schedule & FDTL',
      ),
      drawer: const AviationDrawer(activeIndex: 3),
      body: Column(
        children: [
          // FDTL Cumulative Compliance Overview Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.aeroGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primarySky.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FDTL Regulatory Compliance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'DGCA CAR Sec 7',
                      style: TextStyle(
                        color: AppColors.primarySkyLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FdtlProgressTile(
                        title: '28-Day Flight Time',
                        current: 84.5,
                        max: 100.0,
                        unit: 'hrs',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FdtlProgressTile(
                        title: 'Monthly Duty Time',
                        current: 112.0,
                        max: 190.0,
                        unit: 'hrs',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Duty Type Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _DutyFilterChip(
                    label: 'All Duties',
                    isSelected: _selectedType == null,
                    onTap: () => setState(() => _selectedType = null),
                  ),
                  const SizedBox(width: 8),
                  _DutyFilterChip(
                    label: 'Flight Duty',
                    isSelected: _selectedType == DutyType.flightDuty,
                    onTap: () => setState(() => _selectedType =
                        _selectedType == DutyType.flightDuty ? null : DutyType.flightDuty),
                  ),
                  const SizedBox(width: 8),
                  _DutyFilterChip(
                    label: 'Standby',
                    isSelected: _selectedType == DutyType.standby,
                    onTap: () => setState(() => _selectedType =
                        _selectedType == DutyType.standby ? null : DutyType.standby),
                  ),
                  const SizedBox(width: 8),
                  _DutyFilterChip(
                    label: 'Simulator',
                    isSelected: _selectedType == DutyType.simulator,
                    onTap: () => setState(() => _selectedType =
                        _selectedType == DutyType.simulator ? null : DutyType.simulator),
                  ),
                  const SizedBox(width: 8),
                  _DutyFilterChip(
                    label: 'Rest Period',
                    isSelected: _selectedType == DutyType.restPeriod,
                    onTap: () => setState(() => _selectedType =
                        _selectedType == DutyType.restPeriod ? null : DutyType.restPeriod),
                  ),
                ],
              ),
            ),
          ),

          // Duties List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredDuties.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final duty = filteredDuties[index];
                return DutyCard(
                  duty: duty,
                  onCheckIn: () {
                    state.checkInDuty(duty.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Checked in for ${duty.typeDisplay}!'),
                        backgroundColor: AppColors.successGreen,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FdtlProgressTile extends StatelessWidget {
  final String title;
  final double current;
  final double max;
  final String unit;

  const _FdtlProgressTile({
    required this.title,
    required this.current,
    required this.max,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (current / max).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${current.toStringAsFixed(1)} / ${max.toInt()} $unit',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                ratio > 0.85 ? AppColors.runwayGold : AppColors.cyanAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DutyFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DutyFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySky : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primarySky : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

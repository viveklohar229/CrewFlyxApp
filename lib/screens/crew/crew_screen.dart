import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/crew_model.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/crew_card.dart';
import '../../widgets/empty_state_view.dart';

/// Crew member roster and directory screen with search and filter chips.
class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key});

  @override
  State<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CrewDesignation? _selectedDesignation;
  CrewStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredCrew = state.crewList.where((crew) {
      final matchesQuery = _searchQuery.isEmpty ||
          crew.name.toLowerCase().contains(_searchQuery) ||
          crew.employeeId.toLowerCase().contains(_searchQuery) ||
          crew.baseAirport.toLowerCase().contains(_searchQuery) ||
          crew.assignedFlight.toLowerCase().contains(_searchQuery);

      final matchesDesignation = _selectedDesignation == null ||
          crew.designation == _selectedDesignation;

      final matchesStatus = _selectedStatus == null ||
          crew.status == _selectedStatus;

      return matchesQuery && matchesDesignation && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AviationAppBar(
        title: 'Crew Directory',
        showSearch: true,
        searchController: _searchController,
        onSearchChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
        onSearchClear: () => setState(() => _searchQuery = ''),
      ),
      drawer: const AviationDrawer(activeIndex: 1),
      body: Column(
        children: [
          // Filter Chips Carousel
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: isDark ? AppColors.aeroNavyMedium.withValues(alpha: 0.5) : AppColors.surfaceLight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All Crew',
                    isSelected: _selectedDesignation == null && _selectedStatus == null,
                    onTap: () {
                      setState(() {
                        _selectedDesignation = null;
                        _selectedStatus = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Captains',
                    isSelected: _selectedDesignation == CrewDesignation.captain,
                    onTap: () {
                      setState(() {
                        _selectedDesignation = _selectedDesignation == CrewDesignation.captain
                            ? null
                            : CrewDesignation.captain;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'First Officers',
                    isSelected: _selectedDesignation == CrewDesignation.firstOfficer,
                    onTap: () {
                      setState(() {
                        _selectedDesignation = _selectedDesignation == CrewDesignation.firstOfficer
                            ? null
                            : CrewDesignation.firstOfficer;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Cabin Crew',
                    isSelected: _selectedDesignation == CrewDesignation.cabinCrew ||
                        _selectedDesignation == CrewDesignation.leadCabinCrew,
                    onTap: () {
                      setState(() {
                        _selectedDesignation = _selectedDesignation == CrewDesignation.cabinCrew
                            ? null
                            : CrewDesignation.cabinCrew;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'On Duty',
                    isSelected: _selectedStatus == CrewStatus.onDuty,
                    onTap: () {
                      setState(() {
                        _selectedStatus = _selectedStatus == CrewStatus.onDuty
                            ? null
                            : CrewStatus.onDuty;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Standby',
                    isSelected: _selectedStatus == CrewStatus.standby,
                    onTap: () {
                      setState(() {
                        _selectedStatus = _selectedStatus == CrewStatus.standby
                            ? null
                            : CrewStatus.standby;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Crew List
          Expanded(
            child: filteredCrew.isEmpty
                ? const EmptyStateView(
                    title: 'No Crew Members Found',
                    message: 'Try adjusting your search or filters to find team members.',
                    icon: Icons.person_search_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCrew.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final crew = filteredCrew[index];
                      return CrewCard(
                        crew: crew,
                        onTap: () => _showCrewDetailsSheet(context, crew),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showCrewDetailsSheet(BuildContext context, CrewModel crew) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primarySky.withValues(alpha: 0.15),
                  child: Text(
                    crew.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primarySky,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crew.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.aeroNavy,
                        ),
                      ),
                      Text(
                        crew.designationDisplay,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primarySky,
                        ),
                      ),
                      Text(
                        'Employee ID: ${crew.employeeId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            _DetailRow(icon: Icons.flight, label: 'Rating', value: crew.aircraftRating),
            _DetailRow(icon: Icons.location_on, label: 'Base Airport', value: crew.baseAirport),
            _DetailRow(icon: Icons.timelapse, label: 'Total Flight Hours', value: '${crew.totalHours} hrs'),
            _DetailRow(icon: Icons.phone, label: 'Phone', value: crew.phone),
            _DetailRow(icon: Icons.email, label: 'Email', value: crew.email),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primarySky),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

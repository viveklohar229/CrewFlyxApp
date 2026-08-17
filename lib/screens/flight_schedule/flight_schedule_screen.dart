import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/flight_model.dart';
import '../../state/app_state_provider.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/flight_card.dart';
import '../../widgets/empty_state_view.dart';

/// Flight Schedule screen with route search, status filter, and date picker.
class FlightScheduleScreen extends StatefulWidget {
  const FlightScheduleScreen({super.key});

  @override
  State<FlightScheduleScreen> createState() => _FlightScheduleScreenState();
}

class _FlightScheduleScreenState extends State<FlightScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  FlightStatus? _selectedStatus;
  DateTime? _selectedDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredFlights = state.flights.where((flight) {
      final matchesQuery = _searchQuery.isEmpty ||
          flight.flightNumber.toLowerCase().contains(_searchQuery) ||
          flight.departureAirport.toLowerCase().contains(_searchQuery) ||
          flight.arrivalAirport.toLowerCase().contains(_searchQuery) ||
          flight.departureCity.toLowerCase().contains(_searchQuery) ||
          flight.arrivalCity.toLowerCase().contains(_searchQuery);

      final matchesStatus = _selectedStatus == null || flight.status == _selectedStatus;

      final matchesDate = _selectedDate == null ||
          (flight.departureTime.year == _selectedDate!.year &&
           flight.departureTime.month == _selectedDate!.month &&
           flight.departureTime.day == _selectedDate!.day);

      return matchesQuery && matchesStatus && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AviationAppBar(
        title: 'Flight Schedule',
        showSearch: true,
        searchController: _searchController,
        onSearchChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
        onSearchClear: () => setState(() => _searchQuery = ''),
      ),
      drawer: const AviationDrawer(activeIndex: 2),
      body: Column(
        children: [
          // Filter Bar (Status filters + Date filter button)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: isDark ? AppColors.aeroNavyMedium.withValues(alpha: 0.5) : AppColors.surfaceLight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Date Filter Button
                  ActionChip(
                    avatar: Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: _selectedDate != null ? Colors.white : AppColors.primarySky,
                    ),
                    label: Text(
                      _selectedDate == null
                          ? 'Filter Date'
                          : '${_selectedDate!.day}/${_selectedDate!.month}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _selectedDate != null ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    backgroundColor: _selectedDate != null ? AppColors.primarySky : Colors.white,
                    onPressed: () async {
                      if (_selectedDate != null) {
                        setState(() => _selectedDate = null);
                      } else {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now().add(const Duration(days: 60)),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      }
                    },
                  ),
                  const SizedBox(width: 8),

                  // All status
                  _StatusFilterChip(
                    label: 'All Flights',
                    isSelected: _selectedStatus == null,
                    onTap: () => setState(() => _selectedStatus = null),
                  ),
                  const SizedBox(width: 8),
                  _StatusFilterChip(
                    label: 'Scheduled',
                    isSelected: _selectedStatus == FlightStatus.scheduled,
                    onTap: () => setState(() => _selectedStatus =
                        _selectedStatus == FlightStatus.scheduled ? null : FlightStatus.scheduled),
                  ),
                  const SizedBox(width: 8),
                  _StatusFilterChip(
                    label: 'Boarding',
                    isSelected: _selectedStatus == FlightStatus.boarding,
                    onTap: () => setState(() => _selectedStatus =
                        _selectedStatus == FlightStatus.boarding ? null : FlightStatus.boarding),
                  ),
                  const SizedBox(width: 8),
                  _StatusFilterChip(
                    label: 'Arrived',
                    isSelected: _selectedStatus == FlightStatus.arrived,
                    onTap: () => setState(() => _selectedStatus =
                        _selectedStatus == FlightStatus.arrived ? null : FlightStatus.arrived),
                  ),
                ],
              ),
            ),
          ),

          // Flight Schedule List
          Expanded(
            child: filteredFlights.isEmpty
                ? const EmptyStateView(
                    title: 'No Flights Scheduled',
                    message: 'No commercial flight sectors match your filter criteria.',
                    icon: Icons.flight_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredFlights.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final flight = filteredFlights[index];
                      return FlightCard(
                        flight: flight,
                        onTap: () => _showFlightDetailsDialog(context, flight),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFlightDetailsDialog(BuildContext context, FlightModel flight) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.flight_takeoff, color: AppColors.primarySky),
            const SizedBox(width: 10),
            Text('${flight.flightNumber} Details'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Route: ${flight.departureAirport} (${flight.departureCity}) → ${flight.arrivalAirport} (${flight.arrivalCity})',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text('Aircraft: ${flight.aircraft}'),
            Text('Terminal / Gate: ${flight.terminal} / ${flight.gate}'),
            Text('Flight Distance: ${flight.distanceKm} km'),
            Text('Assigned PIC: ${flight.captainName}'),
            Text('Assigned SIC: ${flight.firstOfficerName}'),
            Text('Role: ${flight.roleDisplay}'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primarySky.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Crew Status: ${flight.crewStatus}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primarySkyDark,
                ),
              ),
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

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusFilterChip({
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

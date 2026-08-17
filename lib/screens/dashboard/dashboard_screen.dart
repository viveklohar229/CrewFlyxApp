import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_layout.dart';
import '../../state/app_state_provider.dart';
import '../../animations/fade_slide_entry.dart';
import '../../widgets/aviation_app_bar.dart';
import '../../widgets/aviation_drawer.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/flight_card.dart';
import '../../widgets/duty_card.dart';
import '../../widgets/custom_charts.dart';

/// Main commercial aviation crew operations dashboard.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = AppStateScope.of(context);
    final user = state.currentUser;
    final stats = state.stats;

    // Filtered flights based on search query
    final displayedFlights = state.flights.where((f) {
      if (_searchQuery.isEmpty) return true;
      return f.flightNumber.toLowerCase().contains(_searchQuery) ||
          f.departureAirport.toLowerCase().contains(_searchQuery) ||
          f.arrivalAirport.toLowerCase().contains(_searchQuery) ||
          f.departureCity.toLowerCase().contains(_searchQuery) ||
          f.arrivalCity.toLowerCase().contains(_searchQuery) ||
          f.aircraft.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AviationAppBar(
        isRoot: true,
        showSearch: true,
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        onSearchClear: () => setState(() => _searchQuery = ''),
      ),
      drawer: const AviationDrawer(activeIndex: 0),
      body: RefreshIndicator(
        color: AppColors.primarySky,
        onRefresh: () => state.refreshDashboard(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Welcome Section
              FadeSlideEntry(
                delay: const Duration(milliseconds: 100),
                child: _buildWelcomeBanner(user, isDark),
              ),

              const SizedBox(height: 20),

              // 2. Statistics Grid
              FadeSlideEntry(
                delay: const Duration(milliseconds: 200),
                child: _buildStatisticsGrid(context, stats),
              ),

              const SizedBox(height: 28),

              // 3. Upcoming Flights Section
              FadeSlideEntry(
                delay: const Duration(milliseconds: 300),
                child: _buildUpcomingFlightsSection(context, displayedFlights),
              ),

              const SizedBox(height: 28),

              // 4. Duty Overview Section
              FadeSlideEntry(
                delay: const Duration(milliseconds: 400),
                child: _buildDutyOverviewSection(context, state),
              ),

              const SizedBox(height: 28),

              // 5. Analytics & Charts Section
              FadeSlideEntry(
                delay: const Duration(milliseconds: 500),
                child: _buildAnalyticsSection(context, stats, isDark),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(dynamic user, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.aeroGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primarySky.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.flight_takeoff, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user?.baseAirport != null
                        ? 'Base: ${user.baseAirport.split(' ')[0]}'
                        : 'Base: DEL (VIDP)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.5)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 12, color: AppColors.successGreen),
                    SizedBox(width: 4),
                    Text(
                      'FDTL Compliant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            AppStrings.welcomeBack,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.overviewSubtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, dynamic stats) {
    final isTablet = ResponsiveLayout.isTablet(context) || ResponsiveLayout.isDesktop(context);
    final columns = isTablet ? 3 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operational Metrics',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: isTablet ? 1.4 : 1.18,
          children: [
            StatCard(
              title: AppStrings.totalFlights,
              value: stats.totalFlights,
              icon: Icons.flight,
              accentColor: AppColors.primarySky,
              subtitle: 'This Month',
              onTap: () => Navigator.of(context).pushNamed('/flight_schedule'),
            ),
            StatCard(
              title: AppStrings.upcomingFlightsCount,
              value: stats.upcomingFlights,
              icon: Icons.upcoming,
              accentColor: AppColors.cyanAccent,
              subtitle: 'Next 7 Days',
              onTap: () => Navigator.of(context).pushNamed('/flight_schedule'),
            ),
            StatCard(
              title: AppStrings.completedFlights,
              value: stats.completedFlights,
              icon: Icons.task_alt,
              accentColor: AppColors.successGreen,
              subtitle: 'Logged',
              onTap: () => Navigator.of(context).pushNamed('/flight_schedule'),
            ),
            StatCard(
              title: AppStrings.pendingDocuments,
              value: stats.pendingDocuments,
              icon: Icons.folder_open,
              accentColor: AppColors.runwayGold,
              subtitle: 'Action Required',
              onTap: () => Navigator.of(context).pushNamed('/documents'),
            ),
            StatCard(
              title: AppStrings.warnings,
              value: stats.warnings,
              icon: Icons.warning_amber_rounded,
              accentColor: AppColors.warningOrange,
              subtitle: 'Safety Notice',
              onTap: () => Navigator.of(context).pushNamed('/warnings_violations'),
            ),
            StatCard(
              title: AppStrings.violations,
              value: stats.violations,
              icon: Icons.gavel,
              accentColor: AppColors.emergencyRed,
              subtitle: 'SOP Review',
              onTap: () => Navigator.of(context).pushNamed('/warnings_violations'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingFlightsSection(BuildContext context, List<dynamic> flights) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.upcomingFlights,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/flight_schedule'),
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primarySky,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primarySky),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (flights.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark
                  : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'No flights matching your search.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: flights.take(2).length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return FlightCard(
                flight: flights[index],
                onTap: () => Navigator.of(context).pushNamed('/flight_schedule'),
              );
            },
          ),
      ],
    );
  }

  Widget _buildDutyOverviewSection(BuildContext context, AppState state) {
    final upcomingDuties = state.duties.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              AppStrings.dutyOverview,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/duty_schedule'),
              child: const Row(
                children: [
                  Text(
                    'Full Roster',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primarySky,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primarySky),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingDuties.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final duty = upcomingDuties[index];
            return DutyCard(
              duty: duty,
              onCheckIn: () {
                state.checkInDuty(duty.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Checked in successfully for ${duty.typeDisplay}!'),
                    backgroundColor: AppColors.successGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              onTap: () => Navigator.of(context).pushNamed('/duty_schedule'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAnalyticsSection(BuildContext context, dynamic stats, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.analyticsSection,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),

        // Monthly Flights Chart Card
        Container(
          padding: const EdgeInsets.all(18),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly Flights Trend',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '2026 Season',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primarySky,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              MonthlyFlightsBarChart(data: stats.monthlyTrends),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Duty Hours Area Chart Card
        Container(
          padding: const EdgeInsets.all(18),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duty Hours Cumulative',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Max 100h / 28 Days',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cyanAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DutyHoursAreaChart(data: stats.monthlyTrends),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Flight Status Distribution Donut Card
        Container(
          padding: const EdgeInsets.all(18),
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
              const Text(
                'Flight Status Distribution',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              FlightStatusDonutChart(data: stats.flightStatusDistribution),
            ],
          ),
        ),
      ],
    );
  }
}

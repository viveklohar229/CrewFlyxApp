/// Statistics point for monthly charts
class MonthlyStatPoint {
  final String month;
  final int flights;
  final double dutyHours;

  const MonthlyStatPoint({
    required this.month,
    required this.flights,
    required this.dutyHours,
  });
}

/// Status distribution point
class StatusDistributionPoint {
  final String status;
  final int count;
  final double percentage;

  const StatusDistributionPoint({
    required this.status,
    required this.count,
    required this.percentage,
  });
}

/// Model encapsulating all metrics shown on the main Aviation Dashboard.
class DashboardStatsModel {
  final int totalFlights;
  final int upcomingFlights;
  final int completedFlights;
  final int pendingDocuments;
  final int warnings;
  final int violations;
  final double totalFlightHours;
  final double monthlyDutyHours;
  final List<MonthlyStatPoint> monthlyTrends;
  final List<StatusDistributionPoint> flightStatusDistribution;

  const DashboardStatsModel({
    required this.totalFlights,
    required this.upcomingFlights,
    required this.completedFlights,
    required this.pendingDocuments,
    required this.warnings,
    required this.violations,
    required this.totalFlightHours,
    required this.monthlyDutyHours,
    required this.monthlyTrends,
    required this.flightStatusDistribution,
  });
}

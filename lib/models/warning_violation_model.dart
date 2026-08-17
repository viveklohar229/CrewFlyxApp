enum SeverityLevel {
  minor,
  moderate,
  severe,
}

enum IssueStatus {
  open,
  underReview,
  acknowledged,
  resolved,
}

/// Model representing safety warnings or FDTL / SOP violation notices.
class WarningViolationModel {
  final String id;
  final bool isViolation; // true = Violation, false = Warning
  final String title;
  final String type; // e.g. "FDTL Rest Deficit", "Late Duty Check-in", "Medical Renewal Pending"
  final DateTime date;
  final String description;
  final SeverityLevel severity;
  final IssueStatus status;
  final String flightNumber;
  final String reportedBy;
  final String? resolutionNotes;

  const WarningViolationModel({
    required this.id,
    required this.isViolation,
    required this.title,
    required this.type,
    required this.date,
    required this.description,
    required this.severity,
    required this.status,
    required this.flightNumber,
    required this.reportedBy,
    this.resolutionNotes,
  });

  WarningViolationModel copyWith({
    String? id,
    bool? isViolation,
    String? title,
    String? type,
    DateTime? date,
    String? description,
    SeverityLevel? severity,
    IssueStatus? status,
    String? flightNumber,
    String? reportedBy,
    String? resolutionNotes,
  }) {
    return WarningViolationModel(
      id: id ?? this.id,
      isViolation: isViolation ?? this.isViolation,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      flightNumber: flightNumber ?? this.flightNumber,
      reportedBy: reportedBy ?? this.reportedBy,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }

  String get severityDisplay {
    switch (severity) {
      case SeverityLevel.minor:
        return 'Minor';
      case SeverityLevel.moderate:
        return 'Moderate';
      case SeverityLevel.severe:
        return 'Critical';
    }
  }

  String get statusDisplay {
    switch (status) {
      case IssueStatus.open:
        return 'Open';
      case IssueStatus.underReview:
        return 'Under Review';
      case IssueStatus.acknowledged:
        return 'Acknowledged';
      case IssueStatus.resolved:
        return 'Resolved';
    }
  }
}

enum DutyType {
  flightDuty,
  standby,
  simulator,
  restPeriod,
  groundTraining,
  medicalCheck,
}

enum DutyStatus {
  upcoming,
  inProgress,
  completed,
  restMandatory,
}

/// Model representing a crew duty assignment compliant with FDTL (Flight Duty Time Limitations).
class DutyModel {
  final String id;
  final DateTime dutyDate;
  final DutyType dutyType;
  final DateTime reportingTime;
  final DateTime releaseTime;
  final String? flightNumber;
  final String location;
  final DutyStatus status;
  final double dutyHours;
  final double blockHours;
  final String remarks;
  final bool isCheckedIn;

  const DutyModel({
    required this.id,
    required this.dutyDate,
    required this.dutyType,
    required this.reportingTime,
    required this.releaseTime,
    this.flightNumber,
    required this.location,
    required this.status,
    required this.dutyHours,
    required this.blockHours,
    required this.remarks,
    this.isCheckedIn = false,
  });

  DutyModel copyWith({
    String? id,
    DateTime? dutyDate,
    DutyType? dutyType,
    DateTime? reportingTime,
    DateTime? releaseTime,
    String? flightNumber,
    String? location,
    DutyStatus? status,
    double? dutyHours,
    double? blockHours,
    String? remarks,
    bool? isCheckedIn,
  }) {
    return DutyModel(
      id: id ?? this.id,
      dutyDate: dutyDate ?? this.dutyDate,
      dutyType: dutyType ?? this.dutyType,
      reportingTime: reportingTime ?? this.reportingTime,
      releaseTime: releaseTime ?? this.releaseTime,
      flightNumber: flightNumber ?? this.flightNumber,
      location: location ?? this.location,
      status: status ?? this.status,
      dutyHours: dutyHours ?? this.dutyHours,
      blockHours: blockHours ?? this.blockHours,
      remarks: remarks ?? this.remarks,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }

  String get typeDisplay {
    switch (dutyType) {
      case DutyType.flightDuty:
        return 'Flight Duty';
      case DutyType.standby:
        return 'Standby (Airport)';
      case DutyType.simulator:
        return 'Full Flight Sim (FFS)';
      case DutyType.restPeriod:
        return 'Mandatory Rest';
      case DutyType.groundTraining:
        return 'Ground Refresher';
      case DutyType.medicalCheck:
        return 'Annual Medical';
    }
  }

  String get statusDisplay {
    switch (status) {
      case DutyStatus.upcoming:
        return 'Upcoming';
      case DutyStatus.inProgress:
        return 'In Progress';
      case DutyStatus.completed:
        return 'Completed';
      case DutyStatus.restMandatory:
        return 'Rest Period';
    }
  }
}

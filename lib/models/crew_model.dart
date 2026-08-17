enum CrewDesignation {
  captain,
  firstOfficer,
  leadCabinCrew,
  cabinCrew,
  flightEngineer,
}

enum CrewStatus {
  onDuty,
  scheduled,
  standby,
  rest,
  leave,
}

/// Model representing a team member in the airline crew roster.
class CrewModel {
  final String id;
  final String name;
  final String employeeId;
  final CrewDesignation designation;
  final String baseAirport;
  final CrewStatus status;
  final String aircraftRating; // e.g. "A320 Type Rated"
  final String phone;
  final String email;
  final int totalHours;
  final String assignedFlight;

  const CrewModel({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.designation,
    required this.baseAirport,
    required this.status,
    required this.aircraftRating,
    required this.phone,
    required this.email,
    required this.totalHours,
    required this.assignedFlight,
  });

  String get designationDisplay {
    switch (designation) {
      case CrewDesignation.captain:
        return 'Captain / Commander';
      case CrewDesignation.firstOfficer:
        return 'First Officer';
      case CrewDesignation.leadCabinCrew:
        return 'Inflight Purser';
      case CrewDesignation.cabinCrew:
        return 'Cabin Attendant';
      case CrewDesignation.flightEngineer:
        return 'Flight Engineer';
    }
  }

  String get statusDisplay {
    switch (status) {
      case CrewStatus.onDuty:
        return 'On Duty';
      case CrewStatus.scheduled:
        return 'Scheduled';
      case CrewStatus.standby:
        return 'Standby';
      case CrewStatus.rest:
        return 'Rest';
      case CrewStatus.leave:
        return 'On Leave';
    }
  }
}

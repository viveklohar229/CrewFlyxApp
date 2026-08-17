enum FlightStatus {
  scheduled,
  boarding,
  departed,
  onTime,
  delayed,
  arrived,
  cancelled,
}

enum CrewRole {
  commander,
  firstOfficer,
  purser,
  cabinCrew,
  supernumerary,
}

/// Model representing a scheduled commercial flight.
class FlightModel {
  final String id;
  final String flightNumber;       // e.g. "CF-1024"
  final String departureAirport;    // e.g. "VNS" (Varanasi)
  final String departureCity;       // e.g. "Varanasi"
  final String arrivalAirport;      // e.g. "DEL" (Delhi)
  final String arrivalCity;        // e.g. "New Delhi"
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String aircraft;           // e.g. "Airbus A320neo (VT-FLX)"
  final String gate;               // e.g. "Gate 4B"
  final String terminal;           // e.g. "T3"
  final FlightStatus status;
  final String crewStatus;         // e.g. "Reporting in 45 min", "Briefing Completed"
  final CrewRole crewRole;
  final String duration;           // e.g. "1h 35m"
  final double distanceKm;
  final String captainName;
  final String firstOfficerName;

  const FlightModel({
    required this.id,
    required this.flightNumber,
    required this.departureAirport,
    required this.departureCity,
    required this.arrivalAirport,
    required this.arrivalCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.aircraft,
    required this.gate,
    required this.terminal,
    required this.status,
    required this.crewStatus,
    required this.crewRole,
    required this.duration,
    required this.distanceKm,
    required this.captainName,
    required this.firstOfficerName,
  });

  String get statusDisplay {
    switch (status) {
      case FlightStatus.scheduled:
        return 'Scheduled';
      case FlightStatus.boarding:
        return 'Boarding';
      case FlightStatus.departed:
        return 'Departed';
      case FlightStatus.onTime:
        return 'On-Time';
      case FlightStatus.delayed:
        return 'Delayed';
      case FlightStatus.arrived:
        return 'Arrived';
      case FlightStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get roleDisplay {
    switch (crewRole) {
      case CrewRole.commander:
        return 'Commander (PIC)';
      case CrewRole.firstOfficer:
        return 'First Officer (SIC)';
      case CrewRole.purser:
        return 'Inflight Purser';
      case CrewRole.cabinCrew:
        return 'Cabin Attendant';
      case CrewRole.supernumerary:
        return 'Observer';
    }
  }
}

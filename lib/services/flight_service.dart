import '../models/flight_model.dart';
import '../mock_data/mock_data.dart';

/// Service for flight schedule management and querying.
class FlightService {
  List<FlightModel> _flights = List.from(MockData.flights);

  Future<List<FlightModel>> getUpcomingFlights() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _flights.where((f) => f.status == FlightStatus.scheduled || f.status == FlightStatus.boarding).toList();
  }

  Future<List<FlightModel>> getAllFlights() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_flights);
  }

  Future<List<FlightModel>> searchFlights(String query) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (query.trim().isEmpty) return _flights;
    final lowerQuery = query.toLowerCase();
    return _flights.where((flight) {
      return flight.flightNumber.toLowerCase().contains(lowerQuery) ||
          flight.departureAirport.toLowerCase().contains(lowerQuery) ||
          flight.arrivalAirport.toLowerCase().contains(lowerQuery) ||
          flight.departureCity.toLowerCase().contains(lowerQuery) ||
          flight.arrivalCity.toLowerCase().contains(lowerQuery) ||
          flight.aircraft.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

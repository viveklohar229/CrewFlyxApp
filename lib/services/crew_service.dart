import '../models/crew_model.dart';
import '../mock_data/mock_data.dart';

/// Service for crew roster search and filtering.
class CrewService {
  List<CrewModel> _crew = List.from(MockData.crewMembers);

  Future<List<CrewModel>> getAllCrew() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_crew);
  }

  Future<List<CrewModel>> searchAndFilterCrew({
    String query = '',
    CrewDesignation? designation,
    CrewStatus? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _crew.where((crew) {
      final matchesQuery = query.isEmpty ||
          crew.name.toLowerCase().contains(query.toLowerCase()) ||
          crew.employeeId.toLowerCase().contains(query.toLowerCase()) ||
          crew.baseAirport.toLowerCase().contains(query.toLowerCase()) ||
          crew.assignedFlight.toLowerCase().contains(query.toLowerCase());

      final matchesDesignation = designation == null || crew.designation == designation;
      final matchesStatus = status == null || crew.status == status;

      return matchesQuery && matchesDesignation && matchesStatus;
    }).toList();
  }
}

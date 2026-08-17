import '../models/duty_model.dart';
import '../mock_data/mock_data.dart';

/// Service for managing crew duties, reporting times, and check-ins.
class DutyService {
  final List<DutyModel> _duties = List.from(MockData.duties);

  Future<List<DutyModel>> getDuties() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_duties);
  }

  Future<DutyModel?> checkInDuty(String dutyId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _duties.indexWhere((d) => d.id == dutyId);
    if (index != -1) {
      final updated = _duties[index].copyWith(
        isCheckedIn: true,
        status: DutyStatus.inProgress,
      );
      _duties[index] = updated;
      return updated;
    }
    return null;
  }
}

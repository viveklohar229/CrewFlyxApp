import '../models/user_model.dart';
import '../mock_data/mock_data.dart';

/// Service responsible for authentication and crew member session management.
class AuthService {
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  /// Mock login supporting validation and delay simulation
  Future<bool> login({
    required String username,
    required String password,
    required String companyCode,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 900));

    // For mock purposes: accept any non-empty input or demo credentials
    if (username.trim().isNotEmpty &&
        password.trim().isNotEmpty &&
        companyCode.trim().isNotEmpty) {
      _currentUser = MockData.currentUser.copyWith(
        username: username.trim(),
        companyCode: companyCode.trim().toUpperCase(),
      );
      _isAuthenticated = true;
      return true;
    }
    return false;
  }

  /// Logout and clear credentials
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _isAuthenticated = false;
  }

  /// Update user profile details
  Future<UserModel> updateProfile(UserModel updatedUser) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = updatedUser;
    return updatedUser;
  }
}

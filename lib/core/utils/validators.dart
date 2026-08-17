import '../constants/app_strings.dart';

/// Form validation utility functions for Crew Flyx inputs.
class Validators {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.usernameRequired;
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  static String? validateCompanyCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.companyCodeRequired;
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid company code';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

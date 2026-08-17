import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/flight_model.dart';
import '../models/duty_model.dart';
import '../models/crew_model.dart';
import '../models/document_model.dart';
import '../models/notification_model.dart';
import '../models/warning_violation_model.dart';
import '../models/dashboard_stats_model.dart';
import '../services/auth_service.dart';
import '../services/flight_service.dart';
import '../services/crew_service.dart';
import '../services/duty_service.dart';
import '../services/document_service.dart';
import '../services/notification_service.dart';
import '../mock_data/mock_data.dart';

/// Central state holder for the Crew Flyx application.
class AppState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlightService _flightService = FlightService();
  final CrewService _crewService = CrewService();
  final DutyService _dutyService = DutyService();
  final DocumentService _documentService = DocumentService();
  final NotificationService _notificationService = NotificationService();

  // Authentication State
  UserModel? _currentUser;
  bool _isLoggingIn = false;
  String? _authError;

  // Theme Mode State
  ThemeMode _themeMode = ThemeMode.light;

  // Search Query
  String _dashboardSearchQuery = '';

  // Data Collections
  List<FlightModel> _flights = [];
  List<DutyModel> _duties = [];
  List<CrewModel> _crewList = [];
  List<DocumentModel> _documents = [];
  List<NotificationModel> _notifications = [];
  List<WarningViolationModel> _warningsViolations = [];
  DashboardStatsModel _stats = MockData.dashboardStats;

  // Loading States
  bool _isLoadingDashboard = false;
  bool _isLoadingCrew = false;
  bool _isLoadingFlights = false;
  bool _isLoadingDocuments = false;

  // Active Menu Index
  int _selectedDrawerIndex = 0;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoggingIn => _isLoggingIn;
  String? get authError => _authError;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  String get dashboardSearchQuery => _dashboardSearchQuery;

  List<FlightModel> get flights => _flights;
  List<DutyModel> get duties => _duties;
  List<CrewModel> get crewList => _crewList;
  List<DocumentModel> get documents => _documents;
  List<NotificationModel> get notifications => _notifications;
  List<WarningViolationModel> get warningsViolations => _warningsViolations;
  DashboardStatsModel get stats => _stats;

  bool get isLoadingDashboard => _isLoadingDashboard;
  bool get isLoadingCrew => _isLoadingCrew;
  bool get isLoadingFlights => _isLoadingFlights;
  bool get isLoadingDocuments => _isLoadingDocuments;
  int get selectedDrawerIndex => _selectedDrawerIndex;

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  AppState() {
    _initData();
  }

  void _initData() {
    _flights = List.from(MockData.flights);
    _duties = List.from(MockData.duties);
    _crewList = List.from(MockData.crewMembers);
    _documents = List.from(MockData.documents);
    _notifications = List.from(MockData.notifications);
    _warningsViolations = List.from(MockData.warningsAndViolations);
  }

  // Actions
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setSelectedDrawerIndex(int index) {
    _selectedDrawerIndex = index;
    notifyListeners();
  }

  void setDashboardSearchQuery(String query) {
    _dashboardSearchQuery = query;
    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
    required String companyCode,
  }) async {
    _isLoggingIn = true;
    _authError = null;
    notifyListeners();

    try {
      final success = await _authService.login(
        username: username,
        password: password,
        companyCode: companyCode,
      );

      if (success) {
        _currentUser = _authService.currentUser;
        _isLoggingIn = false;
        notifyListeners();
        return true;
      } else {
        _authError = 'Invalid credentials or company code.';
        _isLoggingIn = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _authError = 'An error occurred during login. Please try again.';
      _isLoggingIn = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _selectedDrawerIndex = 0;
    _dashboardSearchQuery = '';
    notifyListeners();
  }

  Future<void> refreshDashboard() async {
    _isLoadingDashboard = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));
    _flights = await _flightService.getAllFlights();
    _duties = await _dutyService.getDuties();
    _notifications = await _notificationService.getNotifications();
    _isLoadingDashboard = false;
    notifyListeners();
  }

  Future<void> checkInDuty(String dutyId) async {
    final updated = await _dutyService.checkInDuty(dutyId);
    if (updated != null) {
      final index = _duties.indexWhere((d) => d.id == dutyId);
      if (index != -1) {
        _duties[index] = updated;
        notifyListeners();
      }
    }
  }

  Future<void> markNotificationRead(String id) async {
    await _notificationService.markAsRead(id);
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  Future<void> markAllNotificationsRead() async {
    await _notificationService.markAllAsRead();
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _currentUser = await _authService.updateProfile(updatedUser);
    notifyListeners();
  }

  void acknowledgeWarningOrViolation(String id) {
    final index = _warningsViolations.indexWhere((wv) => wv.id == id);
    if (index != -1) {
      _warningsViolations[index] = _warningsViolations[index].copyWith(
        status: IssueStatus.acknowledged,
      );
      notifyListeners();
    }
  }
}

/// InheritedNotifier for zero-overhead, reactive state consumption anywhere in the widget tree.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}

import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/crew/crew_screen.dart';
import '../../screens/flight_schedule/flight_schedule_screen.dart';
import '../../screens/duty_schedule/duty_schedule_screen.dart';
import '../../screens/documents/documents_screen.dart';
import '../../screens/warnings_violations/warnings_violations_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/settings/settings_screen.dart';

/// Central route manager with smooth slide & fade page transitions.
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String crew = '/crew';
  static const String flightSchedule = '/flight_schedule';
  static const String dutySchedule = '/duty_schedule';
  static const String documents = '/documents';
  static const String warningsViolations = '/warnings_violations';
  static const String notifications = '/notifications';
  static const String reports = '/reports';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    Widget page;
    switch (routeSettings.name) {
      case splash:
        page = const SplashScreen();
        break;
      case login:
        page = const LoginScreen();
        break;
      case dashboard:
        page = const DashboardScreen();
        break;
      case crew:
        page = const CrewScreen();
        break;
      case flightSchedule:
        page = const FlightScheduleScreen();
        break;
      case dutySchedule:
        page = const DutyScheduleScreen();
        break;
      case documents:
        page = const DocumentsScreen();
        break;
      case warningsViolations:
        page = const WarningsViolationsScreen();
        break;
      case notifications:
        page = const NotificationsScreen();
        break;
      case reports:
        page = const ReportsScreen();
        break;
      case profile:
        page = const ProfileScreen();
        break;
      case settings:
        page = const SettingsScreen();
        break;
      default:
        page = const DashboardScreen();
    }

    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Subtle slide from right with gentle curve
        const begin = Offset(0.04, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}

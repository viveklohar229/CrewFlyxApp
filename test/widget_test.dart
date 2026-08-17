import 'package:flutter_test/flutter_test.dart';
import 'package:crew_flyx/main.dart';
import 'package:crew_flyx/core/constants/app_strings.dart';

void main() {
  testWidgets('Crew Flyx app loads splash screen and displays branding', (WidgetTester tester) async {
    // Build Crew Flyx app and trigger initial frame.
    await tester.pumpWidget(const CrewFlyxApp());

    // Verify app branding is displayed on Splash screen
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);

    // Pump past splash timer to verify navigation transition to Login
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();

    // Verify Login screen elements are present
    expect(find.text(AppStrings.loginTitle), findsOneWidget);
    expect(find.text(AppStrings.loginButton), findsOneWidget);
  });
}

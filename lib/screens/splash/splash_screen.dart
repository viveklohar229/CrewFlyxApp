import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../animations/flight_cross_animation.dart';
import '../../animations/cloud_drift_animation.dart';
import '../../widgets/aviation_logo.dart';

/// Aviation-themed 5-second Splash Screen with real PNG Airplane and Helicopter cross-flight animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _flightCrossController;
  late AnimationController _loaderPulseController;
  late AnimationController _contentFadeController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    // Flight cross animation (Airplane bottom-left to top-right, Helicopter top-right to bottom-left)
    _flightCrossController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4800),
    )..forward();

    // Pulse effect for modern radar loader
    _loaderPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Content fade in
    _contentFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    // 5-second timer before automatically transitioning to Login
    _navigationTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _flightCrossController.dispose();
    _loaderPulseController.dispose();
    _contentFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.skyGradient,
        ),
        child: Stack(
          children: [
            // Background Drifting Clouds
            const CloudDriftAnimation(
              cloudColor: Colors.white,
            ),

            // Real PNG Airplane and Helicopter cross-flying and interchanging corners
            FlightCrossAnimation(
              progress: _flightCrossController,
              planeSize: 140,
              heliSize: 120,
            ),

            // Center Branding & Circular Loader
            Center(
              child: FadeTransition(
                opacity: _contentFadeController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Aviation Logo
                    const AviationLogo(
                      size: 84,
                      isDark: true,
                    ),
                    const SizedBox(height: 20),

                    // App Title
                    const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Color(0x33000000),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // App Subtitle
                    Text(
                      AppStrings.appTagline,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Modern Radar Circular Loader
                    AnimatedBuilder(
                      animation: _loaderPulseController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulse Ring
                            Container(
                              width: 52 + (_loaderPulseController.value * 12),
                              height: 52 + (_loaderPulseController.value * 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(
                                  alpha: 0.25 - (_loaderPulseController.value * 0.15),
                                ),
                              ),
                            ),
                            // Spinner
                            const SizedBox(
                              width: 42,
                              height: 42,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            // Center Dot
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 18),

                    // Loading Status Indicator Text
                    Text(
                      AppStrings.loadingSystem,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer Version Info
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  AppStrings.appVersion,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

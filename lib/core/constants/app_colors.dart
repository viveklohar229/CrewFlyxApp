import 'package:flutter/material.dart';

/// Central color definitions for the Crew Flyx aviation theme.
class AppColors {
  // Primary Sky & Aviation Colors
  static const Color primarySky = Color(0xFF0284C7);       // Sky Blue 600
  static const Color primarySkyLight = Color(0xFF38BDF8);  // Light Sky Blue 400
  static const Color primarySkyDark = Color(0xFF0369A1);   // Deep Sky Blue 700
  static const Color skyBackground = Color(0xFFE0F2FE);    // Sky Blue 100
  static const Color skyGlow = Color(0xFFBAE6FD);          // Sky Blue 200

  // Aviation Deep Navies
  static const Color aeroNavy = Color(0xFF0F172A);          // Deep Slate / Jet Navy
  static const Color aeroNavyMedium = Color(0xFF1E293B);    // Slate 800
  static const Color aeroNavyLight = Color(0xFF334155);     // Slate 700
  static const Color cockpitDark = Color(0xFF0B1120);       // Dark Cockpit Black

  // Accent & Status Colors
  static const Color cyanAccent = Color(0xFF06B6D4);        // Flight Radar Cyan
  static const Color runwayGold = Color(0xFFF59E0B);        // Runway / Warning Amber
  static const Color warningOrange = Color(0xFFEA580C);     // Orange 600
  static const Color emergencyRed = Color(0xFFEF4444);      // Red 500
  static const Color successGreen = Color(0xFF10B981);      // Emerald 500
  static const Color infoBlue = Color(0xFF2563EB);          // Royal Blue

  // Neutrals & Surfaces (Light)
  static const Color surfaceLight = Color(0xFFF8FAFC);      // Off-white / Cloud
  static const Color cardLight = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color dividerLight = Color(0xFFF1F5F9);

  // Surfaces (Dark)
  static const Color surfaceDark = Color(0xFF0B132B);
  static const Color cardDark = Color(0xFF1C2541);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF334155);

  // Gradients
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0284C7),
      Color(0xFF38BDF8),
      Color(0xFF7DD3FC),
      Color(0xFFBAE6FD),
    ],
  );

  static const LinearGradient aeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF0369A1),
      Color(0xFF0284C7),
    ],
  );

  static const LinearGradient cardAeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0284C7),
      Color(0xFF0EA5E9),
    ],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF59E0B),
      Color(0xFFD97706),
    ],
  );
}

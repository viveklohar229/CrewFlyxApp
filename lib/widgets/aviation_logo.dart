import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Modern aviation logo with swept wings, supersonic jet silhouette, and radar ring.
class AviationLogo extends StatelessWidget {
  final double size;
  final bool isDark;
  final bool showText;
  final String? subtitle;

  const AviationLogo({
    super.key,
    this.size = 54,
    this.isDark = false,
    this.showText = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.cyanAccent : AppColors.primarySky).withValues(alpha: 0.35),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _AviationLogoPainter(),
      ),
    );

    if (!showText) return logoWidget;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logoWidget,
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Crew Flyx',
              style: TextStyle(
                fontSize: size * 0.42,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: isDark ? Colors.white : AppColors.aeroNavy,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: size * 0.22,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _AviationLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width * 0.4;

    // Outer Radar Arc
    final radarPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035;

    canvas.drawCircle(Offset(cx, cy), radius, radarPaint);

    // Compass marks
    final markPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;

    canvas.drawLine(Offset(cx, cy - radius), Offset(cx, cy - radius + (size.width * 0.08)), markPaint);
    canvas.drawLine(Offset(cx, cy + radius), Offset(cx, cy + radius - (size.width * 0.08)), markPaint);
    canvas.drawLine(Offset(cx - radius, cy), Offset(cx - radius + (size.width * 0.08), cy), markPaint);
    canvas.drawLine(Offset(cx + radius, cy), Offset(cx + radius - (size.width * 0.08), cy), markPaint);

    // Supersonic Jet Silhouette
    final jetPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final jetPath = Path();
    final s = size.width;

    // Nose
    jetPath.moveTo(cx, cy - (s * 0.28));
    // Right wing
    jetPath.lineTo(cx + (s * 0.06), cy - (s * 0.06));
    jetPath.lineTo(cx + (s * 0.32), cy + (s * 0.08));
    jetPath.lineTo(cx + (s * 0.32), cy + (s * 0.14));
    jetPath.lineTo(cx + (s * 0.08), cy + (s * 0.12));
    // Right Tail
    jetPath.lineTo(cx + (s * 0.15), cy + (s * 0.28));
    jetPath.lineTo(cx + (s * 0.08), cy + (s * 0.28));
    jetPath.lineTo(cx, cy + (s * 0.20));
    // Left Tail
    jetPath.lineTo(cx - (s * 0.08), cy + (s * 0.28));
    jetPath.lineTo(cx - (s * 0.15), cy + (s * 0.28));
    jetPath.lineTo(cx - (s * 0.08), cy + (s * 0.12));
    // Left Wing
    jetPath.lineTo(cx - (s * 0.32), cy + (s * 0.14));
    jetPath.lineTo(cx - (s * 0.32), cy + (s * 0.08));
    jetPath.lineTo(cx - (s * 0.06), cy - (s * 0.06));
    jetPath.close();

    canvas.drawPath(jetPath, jetPaint);

    // Center Gold Core Dot
    final corePaint = Paint()
      ..color = AppColors.runwayGold
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy + (s * 0.02)), s * 0.04, corePaint);
  }

  @override
  bool shouldRepaint(covariant _AviationLogoPainter oldDelegate) => false;
}

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated vector airplane flying gracefully across the screen with soft vapor trails.
class AirplaneFlightAnimation extends StatelessWidget {
  final Animation<double> animation;
  final double size;
  final Color planeColor;
  final Color trailColor;

  const AirplaneFlightAnimation({
    super.key,
    required this.animation,
    this.size = 64,
    this.planeColor = Colors.white,
    this.trailColor = const Color(0x66FFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        // Flight path: from left (-0.2) to right (1.2) with a smooth climb curve
        final xFraction = -0.25 + (progress * 1.5);
        final yFraction = 0.35 - (math.sin(progress * math.pi) * 0.18) + ((progress - 0.5) * 0.1);
        final angle = -0.22 + (math.cos(progress * math.pi) * 0.18);

        return LayoutBuilder(
          builder: (context, constraints) {
            final posX = constraints.maxWidth * xFraction;
            final posY = constraints.maxHeight * yFraction;

            return Positioned(
              left: posX,
              top: posY,
              child: Transform.rotate(
                angle: angle,
                child: SizedBox(
                  width: size * 2.2,
                  height: size,
                  child: CustomPaint(
                    painter: _AirplanePainter(
                      planeColor: planeColor,
                      trailColor: trailColor,
                      progress: progress,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AirplanePainter extends CustomPainter {
  final Color planeColor;
  final Color trailColor;
  final double progress;

  _AirplanePainter({
    required this.planeColor,
    required this.trailColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trailPaint = Paint()
      ..shader = LinearGradient(
        colors: [trailColor.withValues(alpha: 0.0), trailColor],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, size.height * 0.35, size.width * 0.5, 4))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Dual Contrails
    canvas.drawLine(
      Offset(0, size.height * 0.42),
      Offset(size.width * 0.55, size.height * 0.42),
      trailPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.58),
      Offset(size.width * 0.55, size.height * 0.58),
      trailPaint,
    );

    // Airplane Body & Wings
    final planePaint = Paint()
      ..color = planeColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final planePath = Path();
    final startX = size.width * 0.5;
    final cy = size.height * 0.5;

    // Fuselage
    planePath.moveTo(startX, cy);
    planePath.lineTo(startX + 15, cy - 3);
    planePath.lineTo(startX + 40, cy - 4);
    // Left Wing
    planePath.lineTo(startX + 35, cy - 24);
    planePath.lineTo(startX + 45, cy - 24);
    planePath.lineTo(startX + 58, cy - 4);
    // Nose
    planePath.lineTo(startX + 75, cy - 1);
    planePath.quadraticBezierTo(startX + 82, cy, startX + 75, cy + 1);
    // Right Wing
    planePath.lineTo(startX + 58, cy + 4);
    planePath.lineTo(startX + 45, cy + 24);
    planePath.lineTo(startX + 35, cy + 24);
    planePath.lineTo(startX + 40, cy + 4);
    // Tail
    planePath.lineTo(startX + 12, cy + 3);
    planePath.lineTo(startX + 5, cy + 12);
    planePath.lineTo(startX, cy + 12);
    planePath.lineTo(startX + 4, cy);
    planePath.close();

    // Shadow & Plane
    canvas.drawPath(planePath.shift(const Offset(2, 6)), shadowPaint);
    canvas.drawPath(planePath, planePaint);

    // Cockpit Window Accent
    final windowPaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(startX + 68, cy),
        width: 6,
        height: 3,
      ),
      windowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AirplanePainter oldDelegate) => true;
}

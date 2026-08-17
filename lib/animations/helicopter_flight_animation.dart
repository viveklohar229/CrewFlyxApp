import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Animated vector helicopter crossing the screen with rotating rotor blades.
class HelicopterFlightAnimation extends StatefulWidget {
  final Animation<double> flightProgress;
  final double size;
  final Color bodyColor;

  const HelicopterFlightAnimation({
    super.key,
    required this.flightProgress,
    this.size = 54,
    this.bodyColor = Colors.white,
  });

  @override
  State<HelicopterFlightAnimation> createState() => _HelicopterFlightAnimationState();
}

class _HelicopterFlightAnimationState extends State<HelicopterFlightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotorController;

  @override
  void initState() {
    super.initState();
    _rotorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
    )..repeat();
  }

  @override
  void dispose() {
    _rotorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.flightProgress, _rotorController]),
      builder: (context, child) {
        final progress = widget.flightProgress.value;
        // Crosses from right (1.2) to left (-0.25)
        final xFraction = 1.2 - (progress * 1.45);
        // Gentle hover oscillation
        final yFraction = 0.58 + (math.sin(progress * 4 * math.pi) * 0.04);
        final pitchAngle = 0.08 + (math.sin(progress * 2 * math.pi) * 0.03);

        return LayoutBuilder(
          builder: (context, constraints) {
            final posX = constraints.maxWidth * xFraction;
            final posY = constraints.maxHeight * yFraction;

            return Positioned(
              left: posX,
              top: posY,
              child: Transform.rotate(
                angle: -pitchAngle, // slight forward pitch when flying
                child: SizedBox(
                  width: widget.size * 1.8,
                  height: widget.size * 1.2,
                  child: CustomPaint(
                    painter: _HelicopterPainter(
                      bodyColor: widget.bodyColor,
                      rotorPhase: _rotorController.value * 2 * math.pi,
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

class _HelicopterPainter extends CustomPainter {
  final Color bodyColor;
  final double rotorPhase;

  _HelicopterPainter({
    required this.bodyColor,
    required this.rotorPhase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = const Color(0xFF0369A1)
      ..style = PaintingStyle.fill;

    final rotorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final skidPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final cx = size.width * 0.45;
    final cy = size.height * 0.55;

    // Main Rotor Mast & Spinning Blades
    final mastTopY = cy - 14;
    canvas.drawLine(Offset(cx, cy - 4), Offset(cx, mastTopY), skidPaint);

    // Dynamic spinning rotor line with perspective width scale
    final rotorRadius = size.width * 0.45;
    final rotorCos = math.cos(rotorPhase);
    final rX1 = cx - (rotorRadius * rotorCos);
    final rX2 = cx + (rotorRadius * rotorCos);
    final rY1 = mastTopY - (3 * math.sin(rotorPhase));
    final rY2 = mastTopY + (3 * math.sin(rotorPhase));

    canvas.drawLine(Offset(rX1, rY1), Offset(rX2, rY2), rotorPaint);

    // Rotor hub disk
    canvas.drawCircle(Offset(cx, mastTopY), 3.0, bodyPaint);

    // Helicopter Fuselage
    final fuselagePath = Path();
    fuselagePath.addOval(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: 38,
        height: 22,
      ),
    );

    // Tail Boom
    final tailPath = Path();
    tailPath.moveTo(cx + 12, cy - 3);
    tailPath.lineTo(cx + 42, cy - 2);
    tailPath.lineTo(cx + 46, cy - 10);
    tailPath.lineTo(cx + 49, cy - 10);
    tailPath.lineTo(cx + 44, cy + 2);
    tailPath.lineTo(cx + 12, cy + 3);
    tailPath.close();

    // Skids (Landing Gear)
    final skidPath = Path();
    skidPath.moveTo(cx - 16, cy + 15);
    skidPath.lineTo(cx + 16, cy + 15);
    skidPath.quadraticBezierTo(cx - 20, cy + 15, cx - 20, cy + 11);

    // Skid struts
    canvas.drawLine(Offset(cx - 10, cy + 9), Offset(cx - 10, cy + 15), skidPaint);
    canvas.drawLine(Offset(cx + 8, cy + 9), Offset(cx + 8, cy + 15), skidPaint);
    canvas.drawPath(skidPath, skidPaint);

    // Draw Shadows
    canvas.drawPath(fuselagePath.shift(const Offset(2, 5)), shadowPaint);
    canvas.drawPath(tailPath.shift(const Offset(2, 5)), shadowPaint);

    // Draw Fuselage & Tail
    canvas.drawPath(fuselagePath, bodyPaint);
    canvas.drawPath(tailPath, bodyPaint);

    // Cockpit Window (Facing Left since flying right-to-left)
    final cockpitPath = Path();
    cockpitPath.moveTo(cx - 6, cy - 7);
    cockpitPath.quadraticBezierTo(cx - 18, cy - 4, cx - 18, cy + 4);
    cockpitPath.lineTo(cx - 6, cy + 6);
    cockpitPath.close();
    canvas.drawPath(cockpitPath, accentPaint);

    // Tail Rotor (Spinning)
    final trX = cx + 47;
    final trY = cy - 6;
    final trRadius = 8.0;
    final trCos = math.cos(rotorPhase * 2);
    final trSin = math.sin(rotorPhase * 2);
    canvas.drawLine(
      Offset(trX - (trRadius * trCos), trY - (trRadius * trSin)),
      Offset(trX + (trRadius * trCos), trY + (trRadius * trSin)),
      rotorPaint,
    );
    canvas.drawCircle(Offset(trX, trY), 2.0, accentPaint);
  }

  @override
  bool shouldRepaint(covariant _HelicopterPainter oldDelegate) => true;
}

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Vector Airplane and Vector Helicopter crossing animation.
/// Airplane flies from Bottom-Left to Top-Right with contrails.
/// Helicopter flies from Top-Right to Bottom-Left with spinning rotor.
/// Both interchange corner positions smoothly without using image files or causing layout errors.
class FlightCrossAnimation extends StatefulWidget {
  final Animation<double> progress;
  final double planeSize;
  final double heliSize;

  const FlightCrossAnimation({
    super.key,
    required this.progress,
    this.planeSize = 64,
    this.heliSize = 56,
  });

  @override
  State<FlightCrossAnimation> createState() => _FlightCrossAnimationState();
}

class _FlightCrossAnimationState extends State<FlightCrossAnimation>
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return AnimatedBuilder(
          animation: Listenable.merge([widget.progress, _rotorController]),
          builder: (context, child) {
            final t = widget.progress.value;

            // 1. Airplane: Starts at Bottom-Left (-0.25, 0.88), ends at Top-Right (1.15, 0.10)
            final planeStartX = -w * 0.25;
            final planeStartY = h * 0.85;
            final planeEndX = w * 1.15;
            final planeEndY = h * 0.08;

            final planeX = planeStartX + (t * (planeEndX - planeStartX));
            final planeY = planeStartY + (t * (planeEndY - planeStartY)) - (math.sin(t * math.pi) * 35);
            const planeAngle = -0.32; // climbing ~ -18 degrees

            // 2. Helicopter: Starts at Top-Right (1.15, 0.12), ends at Bottom-Left (-0.25, 0.82)
            final heliStartX = w * 1.15;
            final heliStartY = h * 0.12;
            final heliEndX = -w * 0.25;
            final heliEndY = h * 0.82;

            final heliX = heliStartX + (t * (heliEndX - heliStartX));
            final heliY = heliStartY + (t * (heliEndY - heliStartY)) + (math.sin(t * 3 * math.pi) * 16);
            final heliAngle = 0.08 + (math.sin(t * 2 * math.pi) * 0.04);

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Airplane Contrail Vapor Trail
                if (t > 0.04 && t < 0.96)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ContrailPainter(
                        startX: planeStartX + 30,
                        startY: planeStartY + 20,
                        currentX: planeX + 20,
                        currentY: planeY + 20,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),

                // 1. Vector Airplane
                Positioned(
                  left: planeX,
                  top: planeY,
                  child: Transform.rotate(
                    angle: planeAngle,
                    child: SizedBox(
                      width: widget.planeSize * 2.0,
                      height: widget.planeSize,
                      child: CustomPaint(
                        painter: _VectorAirplanePainter(
                          planeColor: Colors.white,
                          trailColor: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. Vector Helicopter
                Positioned(
                  left: heliX,
                  top: heliY,
                  child: Transform.rotate(
                    angle: heliAngle,
                    child: SizedBox(
                      width: widget.heliSize * 1.8,
                      height: widget.heliSize * 1.2,
                      child: CustomPaint(
                        painter: _VectorHelicopterPainter(
                          bodyColor: Colors.white,
                          rotorPhase: _rotorController.value * 2 * math.pi,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _VectorAirplanePainter extends CustomPainter {
  final Color planeColor;
  final Color trailColor;

  _VectorAirplanePainter({
    required this.planeColor,
    required this.trailColor,
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
      ..color = Colors.black.withValues(alpha: 0.18)
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
  bool shouldRepaint(covariant _VectorAirplanePainter oldDelegate) => false;
}

class _VectorHelicopterPainter extends CustomPainter {
  final Color bodyColor;
  final double rotorPhase;

  _VectorHelicopterPainter({
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
      ..color = Colors.white.withValues(alpha: 0.9)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final skidPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
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
  bool shouldRepaint(covariant _VectorHelicopterPainter oldDelegate) => true;
}

class _ContrailPainter extends CustomPainter {
  final double startX;
  final double startY;
  final double currentX;
  final double currentY;
  final Color color;

  _ContrailPainter({
    required this.startX,
    required this.startY,
    required this.currentX,
    required this.currentY,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0.0), color],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromPoints(Offset(startX, startY), Offset(currentX, currentY)))
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(startX, startY), Offset(currentX, currentY), paint);
  }

  @override
  bool shouldRepaint(covariant _ContrailPainter oldDelegate) => true;
}

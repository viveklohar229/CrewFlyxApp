import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Real PNG Airplane and Helicopter cross-flight animation.
/// Airplane flies from Bottom-Left to Top-Right.
/// Helicopter flies from Top-Right to Bottom-Left.
/// Both aircraft interchange corner positions across the sky.
class FlightCrossAnimation extends StatelessWidget {
  final Animation<double> progress;
  final double planeSize;
  final double heliSize;

  const FlightCrossAnimation({
    super.key,
    required this.progress,
    this.planeSize = 130,
    this.heliSize = 120,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final t = progress.value;

        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            // 1. Airplane: Starts at Bottom-Left (-0.25, 0.88), ends at Top-Right (1.15, 0.10)
            final planeStartX = -w * 0.30;
            final planeStartY = h * 0.85;
            final planeEndX = w * 1.15;
            final planeEndY = h * 0.08;

            // Smooth curved climb path
            final planeX = planeStartX + (t * (planeEndX - planeStartX));
            final planeY = planeStartY + (t * (planeEndY - planeStartY)) - (math.sin(t * math.pi) * 30);
            const planeAngle = -0.32; // ~ -18 degrees climb

            // 2. Helicopter: Starts at Top-Right (1.15, 0.12), ends at Bottom-Left (-0.25, 0.85)
            final heliStartX = w * 1.15;
            final heliStartY = h * 0.12;
            final heliEndX = -w * 0.30;
            final heliEndY = h * 0.82;

            // Smooth curved descent path with gentle hover oscillation
            final heliX = heliStartX + (t * (heliEndX - heliStartX));
            final heliY = heliStartY + (t * (heliEndY - heliStartY)) + (math.sin(t * 3 * math.pi) * 15);
            final heliAngle = 0.08 + (math.sin(t * 2 * math.pi) * 0.04);

            return Stack(
              children: [
                // Airplane Contrail Line
                if (t > 0.05 && t < 0.95)
                  Positioned(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: CustomPaint(
                      painter: _ContrailPainter(
                        startX: planeStartX + 60,
                        startY: planeStartY + 40,
                        currentX: planeX + 50,
                        currentY: planeY + 30,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                  ),

                // 1. Real Airplane PNG flying Bottom-Left -> Top-Right
                Positioned(
                  left: planeX,
                  top: planeY,
                  child: Transform.rotate(
                    angle: planeAngle,
                    child: SizedBox(
                      width: planeSize * 1.4,
                      height: planeSize * 0.65,
                      child: Image.asset(
                        'assets/images/airplane.png',
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) {
                          return const Icon(
                            Icons.airplanemode_active,
                            size: 60,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // 2. Real Helicopter PNG flying Top-Right -> Bottom-Left
                Positioned(
                  left: heliX,
                  top: heliY,
                  child: Transform.rotate(
                    angle: heliAngle,
                    child: SizedBox(
                      width: heliSize * 1.3,
                      height: heliSize * 0.9,
                      child: Transform.flip(
                        flipX: true, // Face towards left
                        child: Image.asset(
                          'assets/images/helicopter.png',
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) {
                            return const Icon(
                              Icons.flight,
                              size: 60,
                              color: Colors.white,
                            );
                          },
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
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(startX, startY), Offset(currentX, currentY), paint);
  }

  @override
  bool shouldRepaint(covariant _ContrailPainter oldDelegate) => true;
}

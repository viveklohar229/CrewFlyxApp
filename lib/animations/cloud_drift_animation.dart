import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Layered drifting clouds in the sky.
class CloudDriftAnimation extends StatefulWidget {
  final Color cloudColor;

  const CloudDriftAnimation({
    super.key,
    this.cloudColor = const Color(0x33FFFFFF),
  });

  @override
  State<CloudDriftAnimation> createState() => _CloudDriftAnimationState();
}

class _CloudDriftAnimationState extends State<CloudDriftAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final val = _controller.value;

            return Stack(
              children: [
                // Cloud Layer 1 (High, slow, large)
                Positioned(
                  left: -200 + ((val * (w + 400))),
                  top: h * 0.12,
                  child: _CloudShape(
                    width: 220,
                    height: 70,
                    color: widget.cloudColor.withValues(alpha: 0.25),
                  ),
                ),
                // Cloud Layer 2 (Mid, medium speed)
                Positioned(
                  left: w + 100 - (((val * 1.3) % 1.0) * (w + 350)),
                  top: h * 0.45,
                  child: _CloudShape(
                    width: 160,
                    height: 55,
                    color: widget.cloudColor.withValues(alpha: 0.18),
                  ),
                ),
                // Cloud Layer 3 (Lower, subtle)
                Positioned(
                  left: -150 + ((((val * 0.8) + 0.5) % 1.0) * (w + 300)),
                  top: h * 0.72,
                  child: _CloudShape(
                    width: 200,
                    height: 60,
                    color: widget.cloudColor.withValues(alpha: 0.22),
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

class _CloudShape extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _CloudShape({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _SingleCloudPainter(color: color),
    );
  }
}

class _SingleCloudPainter extends CustomPainter {
  final Color color;

  _SingleCloudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Multi-puff cloud path
    final path = Path();
    path.moveTo(w * 0.2, h * 0.8);
    path.lineTo(w * 0.8, h * 0.8);
    path.arcToPoint(Offset(w * 0.8, h * 0.5), radius: Radius.circular(h * 0.3));
    path.arcToPoint(Offset(w * 0.55, h * 0.25), radius: Radius.circular(h * 0.4));
    path.arcToPoint(Offset(w * 0.3, h * 0.35), radius: Radius.circular(h * 0.35));
    path.arcToPoint(Offset(w * 0.15, h * 0.6), radius: Radius.circular(h * 0.3));
    path.arcToPoint(Offset(w * 0.2, h * 0.8), radius: Radius.circular(h * 0.25));
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SingleCloudPainter oldDelegate) => false;
}

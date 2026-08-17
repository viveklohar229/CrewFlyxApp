import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/dashboard_stats_model.dart';
import '../core/constants/app_colors.dart';

/// Animated Bar Chart displaying Monthly Flight count trends.
class MonthlyFlightsBarChart extends StatefulWidget {
  final List<MonthlyStatPoint> data;

  const MonthlyFlightsBarChart({
    super.key,
    required this.data,
  });

  @override
  State<MonthlyFlightsBarChart> createState() => _MonthlyFlightsBarChartState();
}

class _MonthlyFlightsBarChartState extends State<MonthlyFlightsBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 160),
          painter: _BarChartPainter(
            data: widget.data,
            progress: _animation.value,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<MonthlyStatPoint> data;
  final double progress;
  final bool isDark;

  _BarChartPainter({
    required this.data,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.map((e) => e.flights).reduce(math.max).toDouble();
    final chartHeight = size.height - 30;
    final barWidth = (size.width / (data.length * 2)).clamp(16.0, 32.0);
    final totalSpacing = size.width / data.length;

    // Grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06)
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = chartHeight * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final cx = (i * totalSpacing) + (totalSpacing / 2);
      final barHeight = (item.flights / (maxVal * 1.15)) * chartHeight * progress;
      final top = chartHeight - barHeight;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - (barWidth / 2), top, barWidth, barHeight),
        const Radius.circular(6),
      );

      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primarySkyLight,
            AppColors.primarySkyDark,
          ],
        ).createShader(rect.outerRect);

      canvas.drawRRect(rect, barPaint);

      // Value label on top of bar
      if (progress > 0.7) {
        textPainter.text = TextSpan(
          text: '${item.flights}',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.aeroNavy,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(cx - (textPainter.width / 2), top - 14),
        );
      }

      // Month label below bar
      textPainter.text = TextSpan(
        text: item.month,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textMuted : AppColors.textSecondary,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(cx - (textPainter.width / 2), chartHeight + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) => true;
}

/// Animated Area Graph displaying Duty Hours trends.
class DutyHoursAreaChart extends StatefulWidget {
  final List<MonthlyStatPoint> data;

  const DutyHoursAreaChart({
    super.key,
    required this.data,
  });

  @override
  State<DutyHoursAreaChart> createState() => _DutyHoursAreaChartState();
}

class _DutyHoursAreaChartState extends State<DutyHoursAreaChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 160),
          painter: _AreaChartPainter(
            data: widget.data,
            progress: _animation.value,
            isDark: isDark,
          ),
        );
      },
    );
  }
}

class _AreaChartPainter extends CustomPainter {
  final List<MonthlyStatPoint> data;
  final double progress;
  final bool isDark;

  _AreaChartPainter({
    required this.data,
    required this.progress,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.map((e) => e.dutyHours).reduce(math.max);
    final chartHeight = size.height - 30;
    final totalSpacing = size.width / (data.length - 1);

    final linePath = Path();
    final fillPath = Path();

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = i * totalSpacing;
      final normVal = (data[i].dutyHours / (maxVal * 1.2));
      final y = chartHeight - (normVal * chartHeight * progress);
      points.add(Offset(x, y));
    }

    linePath.moveTo(points.first.dx, points.first.dy);
    fillPath.moveTo(points.first.dx, chartHeight);
    fillPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final cx = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
      fillPath.cubicTo(cx, p0.dy, cx, p1.dy, p1.dx, p1.dy);
    }

    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();

    // Fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.cyanAccent.withValues(alpha: isDark ? 0.35 : 0.25),
          AppColors.primarySky.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, chartHeight))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Line
    final linePaint = Paint()
      ..color = AppColors.cyanAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    // Draw Points and labels
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = AppColors.cyanAccent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      canvas.drawCircle(p, 4.5, dotPaint);
      canvas.drawCircle(p, 4.5, dotBorderPaint);

      // Month Label
      textPainter.text = TextSpan(
        text: data[i].month,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textMuted : AppColors.textSecondary,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(p.dx - (textPainter.width / 2), chartHeight + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) => true;
}

/// Animated Donut Chart displaying Flight Status Distribution.
class FlightStatusDonutChart extends StatefulWidget {
  final List<StatusDistributionPoint> data;

  const FlightStatusDonutChart({
    super.key,
    required this.data,
  });

  @override
  State<FlightStatusDonutChart> createState() => _FlightStatusDonutChartState();
}

class _FlightStatusDonutChartState extends State<FlightStatusDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCirc);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final colors = [
      AppColors.successGreen,
      AppColors.warningOrange,
      AppColors.primarySky,
    ];

    return Row(
      children: [
        // Donut Graphic
        SizedBox(
          width: 120,
          height: 120,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: _DonutChartPainter(
                  data: widget.data,
                  colors: colors,
                  progress: _animation.value,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '24',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.aeroNavy,
                        ),
                      ),
                      Text(
                        'Flights',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 24),

        // Legend List
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.data.length, (index) {
              final item = widget.data[index];
              final color = colors[index % colors.length];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '${item.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<StatusDistributionPoint> data;
  final List<Color> colors;
  final double progress;

  _DonutChartPainter({
    required this.data,
    required this.colors,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 14.0;

    double startAngle = -math.pi / 2;
    final total = data.fold<int>(0, (sum, e) => sum + e.count);

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].count / total) * (2 * math.pi) * progress;

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)),
        startAngle + 0.04,
        math.max(0.01, sweepAngle - 0.08),
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) => true;
}

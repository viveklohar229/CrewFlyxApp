import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum BadgeType {
  scheduled,
  boarding,
  departed,
  onTime,
  delayed,
  arrived,
  cancelled,
  active,
  standby,
  rest,
  leave,
  valid,
  pending,
  expiringSoon,
  expired,
  warning,
  violation,
  info,
}

/// Color-coded status badge with clean typography and rounded pill styling.
class StatusBadge extends StatelessWidget {
  final String text;
  final BadgeType type;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = BadgeType.info,
    this.icon,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getBadgeColors(type);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: colors.textColor),
            const SizedBox(width: 4),
          ] else ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.textColor,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: colors.textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeColorConfig _getBadgeColors(BadgeType type) {
    switch (type) {
      case BadgeType.onTime:
      case BadgeType.active:
      case BadgeType.valid:
      case BadgeType.arrived:
        return const _BadgeColorConfig(
          backgroundColor: Color(0xFFECFDF5),
          textColor: Color(0xFF065F46),
          borderColor: Color(0xFFA7F3D0),
        );
      case BadgeType.scheduled:
      case BadgeType.boarding:
      case BadgeType.info:
        return const _BadgeColorConfig(
          backgroundColor: Color(0xFFF0F9FF),
          textColor: Color(0xFF0369A1),
          borderColor: Color(0xFFBAE6FD),
        );
      case BadgeType.delayed:
      case BadgeType.pending:
      case BadgeType.expiringSoon:
      case BadgeType.warning:
      case BadgeType.standby:
        return const _BadgeColorConfig(
          backgroundColor: Color(0xFFFFFBEB),
          textColor: Color(0xFF92400E),
          borderColor: Color(0xFFFDE68A),
        );
      case BadgeType.cancelled:
      case BadgeType.expired:
      case BadgeType.violation:
        return const _BadgeColorConfig(
          backgroundColor: Color(0xFFFEF2F2),
          textColor: Color(0xFF991B1B),
          borderColor: Color(0xFFFECACA),
        );
      case BadgeType.departed:
        return const _BadgeColorConfig(
          backgroundColor: Color(0xFFF5F3FF),
          textColor: Color(0xFF5B21B6),
          borderColor: Color(0xFFDDD6FE),
        );
      case BadgeType.rest:
      case BadgeType.leave:
        return const _BadgeColorConfig(
          backgroundColor: Color(0xFFF1F5F9),
          textColor: Color(0xFF475569),
          borderColor: Color(0xFFCBD5E1),
        );
    }
  }
}

class _BadgeColorConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const _BadgeColorConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}

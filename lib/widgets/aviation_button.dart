import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Modern aviation themed button with gradient, elevation, ripple, and loading spinner.
class AviationButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isFullWidth;
  final bool isOutlined;
  final double height;
  final Color? backgroundColor;

  const AviationButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = true,
    this.isOutlined = false,
    this.height = 52,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveChild = isLoading
        ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: isOutlined ? AppColors.primarySky : Colors.white),
                const SizedBox(width: 10),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: isOutlined ? AppColors.primarySky : Colors.white,
                ),
              ),
            ],
          );

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isOutlined
          ? Colors.transparent
          : (backgroundColor ?? AppColors.primarySky),
      foregroundColor: Colors.white,
      elevation: isOutlined ? 0 : 3,
      shadowColor: (backgroundColor ?? AppColors.primarySky).withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isOutlined
            ? const BorderSide(color: AppColors.primarySky, width: 1.5)
            : BorderSide.none,
      ),
    );

    final btn = SizedBox(
      height: height,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isLoading ? null : onPressed,
        child: effectiveChild,
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: btn,
      );
    }

    return btn;
  }
}

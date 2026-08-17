import 'package:flutter/material.dart';

/// Animated count-up text widget that counts from 0 to the target number.
class CountUpAnimation extends StatefulWidget {
  final int targetNumber;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final bool padTwoDigits;

  const CountUpAnimation({
    super.key,
    required this.targetNumber,
    this.duration = const Duration(milliseconds: 1400),
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.padTwoDigits = true,
  });

  @override
  State<CountUpAnimation> createState() => _CountUpAnimationState();
}

class _CountUpAnimationState extends State<CountUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CountUpAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetNumber != widget.targetNumber) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentVal = (_animation.value * widget.targetNumber).round();
        final text = widget.padTwoDigits
            ? currentVal.toString().padLeft(2, '0')
            : currentVal.toString();

        return Text(
          '${widget.prefix}$text${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}

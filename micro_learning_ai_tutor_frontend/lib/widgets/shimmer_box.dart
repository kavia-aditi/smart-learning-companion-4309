import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class ShimmerBox extends StatefulWidget {
  /// Simple shimmer/skeleton placeholder box.
  /// Use width/height for block skeletons, and borderRadius for rounded looks.
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1200),
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = widget.baseColor ?? const Color(0xFFF2F3F5);
    final hi = widget.highlightColor ?? cs.primary.withAlpha(26);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * _controller.value, 0),
              end: Alignment(1 + 2 * _controller.value, 0),
              colors: [base, hi, base],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}

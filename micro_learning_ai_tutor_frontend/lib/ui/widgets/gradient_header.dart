import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/theme/app_theme.dart';

/// PUBLIC_INTERFACE
class GradientHeader extends StatelessWidget {
  /// Subtle gradient container used to highlight sections/summary.
  /// You can pass [child], [padding], and [borderRadius] to customize.
  const GradientHeader({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.gradients().subtleDiagonal,
        borderRadius: borderRadius,
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

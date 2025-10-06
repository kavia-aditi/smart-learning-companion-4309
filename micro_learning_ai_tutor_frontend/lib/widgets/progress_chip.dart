import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class ProgressChip extends StatelessWidget {
  /// Simple pill chip showing progress text, matching Ocean Professional style.
  const ProgressChip({
    super.key,
    required this.label,
    this.icon,
    this.background,
    this.foreground,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  final String label;
  final IconData? icon;
  final Color? background;
  final Color? foreground;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = background ?? theme.colorScheme.surface;
    final fg = foreground ?? theme.colorScheme.onSurface;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

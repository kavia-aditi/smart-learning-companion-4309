import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class OceanCard extends StatelessWidget {
  /// A reusable card with Ocean Professional style:
  /// - Standard (bordered, flat) or elevated (subtle shadow) variants
  /// - Optional [leading] widget (e.g., icon/avatar)
  /// - Optional [trailing] action (e.g., chevron/button)
  /// - Title/subtitle convenience for common list tiles
  const OceanCard.standard({
    super.key,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  }) : elevated = false;

  const OceanCard.elevated({
    super.key,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  }) : elevated = true;

  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final String? subtitle;
  final Widget? child;
  final bool elevated;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final card = Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: padding,
      child: child ??
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null) Text(title!, style: t.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: t.bodySmall),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ],
            ],
          ),
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: card,
    );
  }
}

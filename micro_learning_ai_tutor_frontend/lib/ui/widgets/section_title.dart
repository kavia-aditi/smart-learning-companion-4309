import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class SectionTitle extends StatelessWidget {
  /// Standardized section header using theme's title styles.
  const SectionTitle(this.text, {super.key, this.uppercase = false});

  final String text;
  final bool uppercase;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Text(
      uppercase ? text.toUpperCase() : text,
      style: t.titleMedium,
    );
  }
}

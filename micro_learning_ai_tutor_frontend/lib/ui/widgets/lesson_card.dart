import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class LessonCard extends StatelessWidget {
  /// Lesson card displaying title, duration/badges, and a progress bar.
  const LessonCard({
    super.key,
    required this.title,
    required this.duration,
    this.badges = const <String>[],
    this.progress = 0.0,
  });

  final String title;
  final String duration;
  final List<String> badges;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: t.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(text: duration),
              ...badges.map((b) => _Badge(text: b)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 8,
              backgroundColor: const Color(0xFFF3F4F6),
              color: cs.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

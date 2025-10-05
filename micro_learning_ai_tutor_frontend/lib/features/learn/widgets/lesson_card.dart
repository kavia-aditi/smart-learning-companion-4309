import 'package:flutter/material.dart';
import '../../../core/models/lesson.dart';

/// PUBLIC_INTERFACE
class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson, required this.progress, this.onTap});

  final Lesson lesson;
  final int progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lesson.title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(lesson.summary, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666A70))),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(label: Text('${lesson.durationMinutes} min')),
                const SizedBox(width: 8),
                Chip(label: Text('$progress%')),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress.clamp(0, 100) / 100.0,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
          ],
        ),
      ),
    );
  }
}

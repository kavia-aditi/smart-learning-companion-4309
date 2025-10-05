import 'package:flutter/material.dart';
import '../../../core/models/lesson.dart';
import '../../../app.dart' show kReduceMotion;

/// PUBLIC_INTERFACE
class LessonCard extends StatefulWidget {
  const LessonCard({super.key, required this.lesson, required this.progress, this.onTap});

  final Lesson lesson;
  final int progress;
  final VoidCallback? onTap;

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = _pressed && !kReduceMotion ? 0.99 : 1.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 90),
        scale: scale,
        child: Container(
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
              Hero(
                tag: 'lesson-title-${widget.lesson.id}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(widget.lesson.title, style: theme.textTheme.titleMedium),
                ),
              ),
              const SizedBox(height: 6),
              Text(widget.lesson.summary, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666A70))),
              const SizedBox(height: 10),
              Row(
                children: [
                  Chip(label: Text('${widget.lesson.durationMinutes} min')),
                  const SizedBox(width: 8),
                  Chip(label: Text('${widget.progress}%')),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: widget.progress.clamp(0, 100) / 100.0,
                minHeight: 6,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

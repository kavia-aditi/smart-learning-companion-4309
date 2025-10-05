import 'package:flutter/material.dart';
import '../../../core/models/quiz.dart';
import '../../../app.dart' show kReduceMotion;

/// PUBLIC_INTERFACE
class QuizCard extends StatefulWidget {
  const QuizCard({super.key, required this.quiz, this.onStart});

  final Quiz quiz;
  final VoidCallback? onStart;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = _pressed && !kReduceMotion ? 0.99 : 1.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
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
              Text(widget.quiz.title, style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(widget.quiz.description, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666A70))),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: widget.onStart, child: const Text('Start quiz')),
            ],
          ),
        ),
      ),
    );
  }
}

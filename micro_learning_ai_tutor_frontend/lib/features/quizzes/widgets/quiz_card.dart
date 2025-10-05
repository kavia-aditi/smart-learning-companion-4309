import 'package:flutter/material.dart';
import '../../../core/models/quiz.dart';

/// PUBLIC_INTERFACE
class QuizCard extends StatelessWidget {
  const QuizCard({super.key, required this.quiz, this.onStart});

  final Quiz quiz;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
          Text(quiz.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(quiz.description, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666A70))),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onStart, child: const Text('Start quiz')),
        ],
      ),
    );
  }
}

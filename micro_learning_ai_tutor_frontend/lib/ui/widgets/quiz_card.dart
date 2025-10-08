import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class QuizCard extends StatelessWidget {
  /// Quiz card displaying title, number of questions, and difficulty badge.
  const QuizCard({
    super.key,
    required this.title,
    required this.questions,
    required this.difficulty,
  });

  final String title;
  final int questions;
  final String difficulty;

  Color _badgeColor(String diff, ColorScheme cs) {
    switch (diff.toLowerCase()) {
      case 'easy':
        return const Color(0xFF10B981); // teal/green
      case 'hard':
        return const Color(0xFFEF4444); // red
      default:
        return cs.tertiary; // accent blue
    }
  }

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
      child: Row(
        children: [
          Icon(Icons.quiz, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.titleMedium),
                const SizedBox(height: 4),
                Text('$questions questions', style: t.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _badgeColor(difficulty, cs).withAlpha(24),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _badgeColor(difficulty, cs)),
            ),
            child: Text(
              difficulty,
              style: TextStyle(
                color: _badgeColor(difficulty, cs),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/ocean_card.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/section_title.dart';

/// PUBLIC_INTERFACE
class QuizzesScreen extends StatelessWidget {
  /// Base screen for Quizzes tab. Shows placeholder quiz previews.
  const QuizzesScreen({super.key});

  Widget _difficultyChip(BuildContext context, String difficulty, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    Widget buildQuiz({
      required IconData icon,
      required String title,
      required int questions,
      required String difficulty,
      required Color color,
    }) {
      return OceanCard.standard(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: cs.tertiary.withAlpha(22),
          child: Icon(icon, color: cs.tertiary),
        ),
        title: title,
        subtitle: '$questions questions',
        trailing: _difficultyChip(context, difficulty, color),
        onTap: () {},
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Quick checks to reinforce your learning.', style: t.bodyMedium),
        const SizedBox(height: 12),
        const SectionTitle('Quizzes'),
        const SizedBox(height: 8),
        buildQuiz(
          icon: Icons.quiz_outlined,
          title: 'Daily Quiz',
          questions: 5,
          difficulty: 'Easy',
          color: const Color(0xFF10B981),
        ),
        const SizedBox(height: 12),
        buildQuiz(
          icon: Icons.biotech_outlined,
          title: 'Science Mix',
          questions: 8,
          difficulty: 'Medium',
          color: cs.tertiary,
        ),
        const SizedBox(height: 12),
        buildQuiz(
          icon: Icons.psychology_alt_outlined,
          title: 'Critical Thinking',
          questions: 10,
          difficulty: 'Hard',
          color: const Color(0xFFEF4444),
        ),
      ],
    );
  }
}

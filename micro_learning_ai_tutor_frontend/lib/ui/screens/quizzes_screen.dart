import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/sample_card.dart';

/// PUBLIC_INTERFACE
class QuizzesScreen extends StatelessWidget {
  /** Base screen for Quizzes tab. Shows placeholder quiz items. */
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Quick checks to reinforce your learning.', style: t.bodyMedium),
        const SizedBox(height: 12),
        const SampleCard(
          title: 'Daily Quiz',
          subtitle: '5 questions • Easy',
          icon: Icons.quiz,
        ),
        const SizedBox(height: 12),
        const SampleCard(
          title: 'Science Mix',
          subtitle: '8 questions • Medium',
          icon: Icons.biotech_outlined,
        ),
      ],
    );
  }
}

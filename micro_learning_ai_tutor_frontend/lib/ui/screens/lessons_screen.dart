import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/sample_card.dart';

/// PUBLIC_INTERFACE
class LessonsScreen extends StatelessWidget {
  /** Base screen for Lessons tab. Shows placeholder content and sample card. */
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Browse your micro-lessons below.', style: t.bodyMedium),
        const SizedBox(height: 12),
        const SampleCard(
          title: 'Impressionism Art Movement',
          subtitle: '7 min • Art • Intermediate',
          icon: Icons.menu_book,
        ),
        const SizedBox(height: 12),
        const SampleCard(
          title: 'Basics of Algebra',
          subtitle: '8 min • Math • Beginner',
          icon: Icons.calculate_outlined,
        ),
      ],
    );
  }
}

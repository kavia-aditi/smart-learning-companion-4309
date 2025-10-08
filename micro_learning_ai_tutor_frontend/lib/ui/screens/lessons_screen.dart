import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/ocean_card.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/section_title.dart';

/// PUBLIC_INTERFACE
class LessonsScreen extends StatelessWidget {
  /// Base screen for Lessons tab. Shows placeholder lesson cards with progress.
  const LessonsScreen({super.key});

  Widget _progressChip(BuildContext context, String text) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.primary),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: cs.primary,
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

    Widget buildLesson({
      required IconData icon,
      required String title,
      required String duration,
      required String progress,
    }) {
      return OceanCard.standard(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: cs.primary.withAlpha(24),
          child: Icon(icon, color: cs.primary),
        ),
        title: title,
        subtitle: '$duration • Lesson',
        trailing: _progressChip(context, progress),
        onTap: () {},
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Browse your micro-lessons below.', style: t.bodyMedium),
        const SizedBox(height: 12),
        const SectionTitle('Lessons'),
        const SizedBox(height: 8),
        buildLesson(
          icon: Icons.history_edu_outlined,
          title: 'Impressionism Art Movement',
          duration: '7 min',
          progress: '20%',
        ),
        const SizedBox(height: 12),
        buildLesson(
          icon: Icons.calculate_outlined,
          title: 'Basics of Algebra',
          duration: '8 min',
          progress: '55%',
        ),
        const SizedBox(height: 12),
        buildLesson(
          icon: Icons.biotech_outlined,
          title: 'Intro to Photosynthesis',
          duration: '6 min',
          progress: '70%',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/lessons_provider.dart';

/// PUBLIC_INTERFACE
class LessonDetailScreen extends ConsumerWidget {
  /// Shows the currently selected lesson content blocks and CTA to start quiz.
  const LessonDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(selectedLessonProvider);
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: const Center(child: Text('No lesson selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(lesson.description, style: t.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(cs, lesson.level),
              ...lesson.tags.map((e) => _chip(cs, e)),
            ],
          ),
          const SizedBox(height: 16),
          ...lesson.content.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(p, style: t.bodyLarge),
              )),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/quiz'),
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _chip(ColorScheme cs, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outline),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}

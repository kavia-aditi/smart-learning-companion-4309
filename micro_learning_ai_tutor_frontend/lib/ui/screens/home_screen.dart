import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/lessons_provider.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/lesson_card.dart';

/// PUBLIC_INTERFACE
class HomeScreen extends ConsumerWidget {
  /// Home screen showing lessons list powered by Riverpod mock data.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonsProvider);
    final t = Theme.of(context).textTheme;

    return lessonsAsync.when(
      data: (lessons) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: lessons.length + 1,
        itemBuilder: (_, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('Lessons', style: t.titleMedium),
            );
          }
          final lesson = lessons[i - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                ref.read(selectedLessonIdProvider.notifier).state = lesson.id;
                Navigator.of(context).pushNamed('/lesson-detail');
              },
              borderRadius: BorderRadius.circular(12),
              child: LessonCard(
                title: lesson.title,
                duration: lesson.prettyDuration,
                badges: [lesson.level, ...lesson.tags.take(2)],
                progress: 0.0,
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Failed to load lessons: $e')),
    );
  }
}

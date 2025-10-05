import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/lesson_repository.dart';
import '../../core/models/lesson.dart';
import '../../core/state/app_state.dart';

/// PUBLIC_INTERFACE
class LessonDetailScreen extends StatefulWidget {
  const LessonDetailScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final _repo = LessonRepository();
  Lesson? _lesson;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final l = await _repo.getById(widget.lessonId);
    setState(() => _lesson = l);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lesson = _lesson;
    if (lesson == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress = context.select<AppState, int>(
      (s) => s.lessonProgress[lesson.id] ?? lesson.progress,
    );

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(lesson.summary, style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF666A70))),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('${lesson.durationMinutes} min')),
              Chip(label: Text('$progress% complete')),
            ],
          ),
          const SizedBox(height: 16),
          Text('Sections', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final s in lesson.sections)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(s),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: ElevatedButton(
          onPressed: () {
            // simulate progress advance in-memory
            final app = context.read<AppState>();
            final next = (progress + 20).clamp(0, 100);
            app.updateLessonProgress(lesson.id, next);
            if (next >= 100) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lesson completed!')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Progress updated to $next%')));
            }
          },
          child: const Text('Start micro-lesson'),
        ),
      ),
    );
  }
}

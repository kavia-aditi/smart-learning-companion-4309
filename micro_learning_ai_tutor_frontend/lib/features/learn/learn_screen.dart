import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/lesson_repository.dart';
import '../../core/models/lesson.dart';
import '../../core/state/app_state.dart';
import 'lesson_detail_screen.dart';
import 'widgets/lesson_card.dart';

/// PUBLIC_INTERFACE
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final _repo = LessonRepository();
  List<Lesson> _lessons = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _repo.list();
    setState(() {
      _lessons = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final lesson = _lessons[i];
        final progress = context.select<AppState, int>((s) => s.lessonProgress[lesson.id] ?? lesson.progress);
        return LessonCard(
          lesson: lesson,
          progress: progress,
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => LessonDetailScreen(lessonId: lesson.id),
            ));
          },
        );
      },
    );
  }
}

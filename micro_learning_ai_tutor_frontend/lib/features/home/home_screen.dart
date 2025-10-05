import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/lesson_repository.dart';
import '../../core/models/lesson.dart';
import '../../core/state/app_state.dart';
import '../learn/lesson_detail_screen.dart';
import 'widgets/progress_summary.dart';

/// PUBLIC_INTERFACE
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final cs = theme.colorScheme;

    return LayoutBuilder(builder: (context, constraints) {
      final isTablet = constraints.maxWidth >= 768;
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: isTablet ? 28 : 22,
                    backgroundColor: const Color(0xFFDDEBFF),
                    child: Icon(Icons.school, color: cs.primary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back, Learner', style: theme.textTheme.titleMedium),
                      Text(
                        'Learn any topic in 5-minute lessons',
                        style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF666A70)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress summary
              const ProgressSummary(),

              const SizedBox(height: 16),

              Text('Suggested lessons', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),

              if (_loading)
                const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _lessons.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final lesson = _lessons[index];
                      final progress = context.select<AppState, int>(
                        (s) => s.lessonProgress[lesson.id] ?? lesson.progress,
                      );
                      return _LessonCardHorizontal(
                        lesson: lesson,
                        progress: progress,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => LessonDetailScreen(lessonId: lesson.id),
                          ));
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _LessonCardHorizontal extends StatelessWidget {
  const _LessonCardHorizontal({required this.lesson, required this.progress, this.onTap});

  final Lesson lesson;
  final int progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 260,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 6, offset: const Offset(0, 2)),
          ],
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary.withAlpha(8), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lesson.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('${lesson.durationMinutes} min', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF8A8F96))),
            const Spacer(),
            LinearProgressIndicator(
              value: progress.clamp(0, 100) / 100.0,
              minHeight: 6,
              borderRadius: BorderRadius.circular(999),
            ),
            const SizedBox(height: 6),
            Text('$progress% complete', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666A70))),
          ],
        ),
      ),
    );
  }
}

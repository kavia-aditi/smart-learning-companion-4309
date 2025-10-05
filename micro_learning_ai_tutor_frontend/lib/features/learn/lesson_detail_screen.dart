import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/lesson_repository.dart';
import '../../core/models/lesson.dart';
import '../../core/state/app_state.dart';
import '../../app.dart' show kReduceMotion;

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
  bool _pressed = false;

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
    final cs = theme.colorScheme;
    final lesson = _lesson;
    if (lesson == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final progress = context.select<AppState, int>(
      (s) => s.lessonProgress[lesson.id] ?? lesson.progress,
    );

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'lesson-title-${lesson.id}',
          child: Material(
            type: MaterialType.transparency,
            child: Text(lesson.title, style: theme.textTheme.titleLarge),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary.withAlpha(20), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 250),
        child: ListView(
          key: ValueKey(lesson.id),
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
            for (int i = 0; i < lesson.sections.length; i++)
              _SectionAppear(
                key: ValueKey('sec-$i'),
                delayMs: kReduceMotion ? 0 : i * 40,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 3, offset: const Offset(0, 1))],
                  ),
                  child: Text(lesson.sections[i]),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          onTap: () {
            final app = context.read<AppState>();
            final next = (progress + 20).clamp(0, 100);
            app.updateLessonProgress(lesson.id, next);
            if (next >= 100) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lesson completed!')));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Progress updated to $next%')));
            }
          },
          child: AnimatedScale(
            duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 90),
            scale: _pressed ? 0.98 : 1,
            child: const ElevatedButton(
              onPressed: null, // onTap handled by GestureDetector above
              child: Text('Start micro-lesson'),
            ),
          ),
        ),
      ),
    );
  }
}

// Local helper appear animation for sections list
class _SectionAppear extends StatefulWidget {
  const _SectionAppear({super.key, required this.child, this.delayMs = 0});
  final Widget child;
  final int delayMs;

  @override
  State<_SectionAppear> createState() => _SectionAppearState();
}

class _SectionAppearState extends State<_SectionAppear> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 220),
  );
  late final Animation<double> _a = CurvedAnimation(parent: _c, curve: Curves.easeOut);

  @override
  void initState() {
    super.initState();
    if (kReduceMotion || widget.delayMs == 0) {
      _c.forward();
    } else {
      Future<void>.delayed(Duration(milliseconds: widget.delayMs), () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kReduceMotion) return widget.child;
    return AnimatedBuilder(
      animation: _a,
      builder: (context, _) {
        final v = _a.value;
        return Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, (1 - v) * 8), child: widget.child),
        );
      },
    );
  }
}

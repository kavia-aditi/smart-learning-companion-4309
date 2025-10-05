import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/lesson_repository.dart';
import '../../core/models/lesson.dart';
import '../../core/state/app_state.dart';
import 'lesson_detail_screen.dart';
import 'widgets/lesson_card.dart';
import '../../widgets/shimmer_box.dart';
import '../../app.dart' show kReduceMotion;

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
    if (_loading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, __) => const ShimmerBox(height: 120, borderRadius: 12),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _lessons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final lesson = _lessons[i];
        final progress = context.select<AppState, int>((s) => s.lessonProgress[lesson.id] ?? lesson.progress);
        final delayMs = kReduceMotion ? 0 : i * 40;
        return _ListAppear(
          delayMs: delayMs,
          child: LessonCard(
            lesson: lesson,
            progress: progress,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => LessonDetailScreen(lessonId: lesson.id),
              ));
            },
          ),
        );
      },
    );
  }
}

// Local helper for delayed appear animation
class _ListAppear extends StatefulWidget {
  const _ListAppear({required this.child, this.delayMs = 0});
  final Widget child;
  final int delayMs;

  @override
  State<_ListAppear> createState() => _ListAppearState();
}

class _ListAppearState extends State<_ListAppear> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 250),
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
          child: Transform.translate(offset: Offset(0, (1 - v) * 10), child: widget.child),
        );
      },
    );
  }
}

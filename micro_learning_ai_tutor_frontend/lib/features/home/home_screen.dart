import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/lesson_repository.dart';
import '../../core/models/lesson.dart';
import '../../core/state/app_state.dart';
import '../learn/lesson_detail_screen.dart';
import 'widgets/progress_summary.dart';
import '../../widgets/shimmer_box.dart';
import '../../app.dart' show kReduceMotion;
import '../../widgets/animated_header.dart';

/// PUBLIC_INTERFACE
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Simple configuration to enable/disable header animation and adjust speed.
  static const bool enableHeaderAnimation = true;
  static const double headerSpeed = 1.0;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated header area - Ocean Professional theme
              AnimatedHeader(
                title: 'Welcome back 👋',
                enableAnimation: HomeScreen.enableHeaderAnimation && !kReduceMotion,
                speedFactor: HomeScreen.headerSpeed,
                height: isTablet ? 220 : 200,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
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
                        AnimatedDefaultTextStyle(
                          duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 200),
                          style: theme.textTheme.bodyMedium!.copyWith(color: const Color(0xFF666A70)),
                          child: const Text('Learn any topic in 5-minute lessons'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Progress summary
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ProgressSummary(),
              ),

              const SizedBox(height: 16),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Suggested lessons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),

              if (_loading)
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, __) => const ShimmerBox(width: 260, height: 160, borderRadius: 12),
                  ),
                )
              else
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: _lessons.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final lesson = _lessons[index];
                      final progress = context.select<AppState, int>(
                        (s) => s.lessonProgress[lesson.id] ?? lesson.progress,
                      );
                      // Slide+fade in per item
                      final delayMs = kReduceMotion ? 0 : 60 * index;
                      return _AnimatedAppear(
                        delayMs: delayMs,
                        child: _LessonCardHorizontal(
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
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _AnimatedAppear extends StatefulWidget {
  const _AnimatedAppear({required this.child, this.delayMs = 0});
  final Widget child;
  final int delayMs;

  @override
  State<_AnimatedAppear> createState() => _AnimatedAppearState();
}

class _AnimatedAppearState extends State<_AnimatedAppear> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 280),
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
          child: Transform.translate(offset: Offset(0, (1 - v) * 12), child: widget.child),
        );
      },
    );
  }
}

class _LessonCardHorizontal extends StatefulWidget {
  const _LessonCardHorizontal({required this.lesson, required this.progress, this.onTap});

  final Lesson lesson;
  final int progress;
  final VoidCallback? onTap;

  @override
  State<_LessonCardHorizontal> createState() => _LessonCardHorizontalState();
}

class _LessonCardHorizontalState extends State<_LessonCardHorizontal> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scale = _pressed && !kReduceMotion ? 0.98 : 1.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 90),
        scale: scale,
        child: Container(
          width: 260,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(_pressed ? 6 : 18), blurRadius: _pressed ? 3 : 6, offset: const Offset(0, 2)),
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
              Hero(
                tag: 'lesson-title-${widget.lesson.id}',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    widget.lesson.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text('${widget.lesson.durationMinutes} min',
                  style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF8A8F96))),
              const Spacer(),
              LinearProgressIndicator(
                value: widget.progress.clamp(0, 100) / 100.0,
                minHeight: 6,
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 6),
              Text('${widget.progress}% complete',
                  style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666A70))),
            ],
          ),
        ),
      ),
    );
  }
}

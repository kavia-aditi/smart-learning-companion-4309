import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/lesson_repository.dart';
import '../../core/models/lesson.dart';
import '../../core/state/app_state.dart';
import '../learn/lesson_detail_screen.dart';
import '../learn/learn_screen.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/featured_lesson_card.dart';
import '../../widgets/lesson_category_card.dart';
import '../../app.dart' show kReduceMotion;

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 360;
        final heroHeight = isSmall ? 120.0 : 140.0;

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Header row: Title + icons
                      _HeaderRow(),
                      const SizedBox(height: 16),

                      // Continue Learning hero
                      FeaturedLessonCard(
                        height: heroHeight,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const LearnScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // Data Science progress block
                      Text(
                        'Data Science',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0B132B),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '2 of 5 lessons',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Popular Courses
                      Text(
                        'Popular Courses',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0B132B),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Grid of categories
                      _CoursesGrid(),
                      const SizedBox(height: 24),

                      // Suggested lessons horizontal list from repository (existing)
                      Text(
                        'Suggested lessons',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF111827),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              if (_loading)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) =>
                          const ShimmerBox(width: 260, height: 160, borderRadius: 12),
                    ),
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: SizedBox(
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
                        final delayMs = kReduceMotion ? 0 : 60 * index;
                        return _AnimatedAppear(
                          delayMs: delayMs,
                          child: _LessonCardHorizontal(
                            lesson: lesson,
                            progress: progress,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      LessonDetailScreen(lessonId: lesson.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderRow extends StatefulWidget {
  @override
  State<_HeaderRow> createState() => _HeaderRowState();
}

class _HeaderRowState extends State<_HeaderRow> {
  bool _p1 = false;
  bool _p2 = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Quick Learning',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0B132B),
                  letterSpacing: -0.2,
                ),
          ),
        ),
        _CircleIconButton(
          icon: Icons.search,
          pressed: _p1,
          onTapDown: () => setState(() => _p1 = true),
          onTapUpOrCancel: () => setState(() => _p1 = false),
        ),
        const SizedBox(width: 12),
        _CircleIconButton(
          icon: Icons.notifications_none_rounded,
          pressed: _p2,
          onTapDown: () => setState(() => _p2 = true),
          onTapUpOrCancel: () => setState(() => _p2 = false),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.pressed,
    required this.onTapDown,
    required this.onTapUpOrCancel,
  });

  final IconData icon;
  final bool pressed;
  final VoidCallback onTapDown;
  final VoidCallback onTapUpOrCancel;

  @override
  Widget build(BuildContext context) {
    final double scale = pressed ? 0.98 : 1.0;
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUpOrCancel(),
      onTapCancel: onTapUpOrCancel,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: scale,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Icon(Icons.search, color: Color(0xFF1F3C88)),
        ),
      ),
    );
  }
}

class _CoursesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // childAspectRatio ~ 1.9 matches spec; adjust slightly for very small phones.
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;
    final aspect = isSmall ? 1.8 : 1.9;

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: aspect,
      children: const [
        LessonCategoryCard(
          title: 'Python',
          backgroundColor: Color(0xFFF9C74F),
          icon: Icons.play_arrow_rounded,
          textColor: Color(0xFF1F2937),
        ),
        LessonCategoryCard(
          title: 'Web Development',
          backgroundColor: Color(0xFF6C63FF),
          icon: Icons.code_rounded,
          textColor: Colors.white,
        ),
        LessonCategoryCard(
          title: 'Machine Learning',
          backgroundColor: Color(0xFF22C58B),
          icon: Icons.show_chart_rounded,
          textColor: Colors.white,
        ),
        LessonCategoryCard(
          title: 'Graphic Design',
          backgroundColor: Color(0xFFFF5CA8),
          icon: Icons.bar_chart_rounded,
          textColor: Colors.white,
        ),
      ],
    );
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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(_pressed ? 15 : 25),
                blurRadius: _pressed ? 6 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0B132B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.lesson.durationMinutes} min',
                      style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: widget.progress.clamp(0, 100) / 100.0,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.progress}% complete',
                    style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

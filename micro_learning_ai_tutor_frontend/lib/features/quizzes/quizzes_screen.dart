import 'package:flutter/material.dart';

import '../../core/models/quiz.dart';
import '../../core/repositories/quiz_repository.dart';
import 'quiz_attempt_screen.dart';
import 'widgets/quiz_card.dart';
import '../../widgets/shimmer_box.dart';
import '../../app.dart' show kReduceMotion;

/// PUBLIC_INTERFACE
class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  final _repo = QuizRepository();
  List<Quiz> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final qs = await _repo.list();
    setState(() {
      _items = qs;
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
        itemBuilder: (_, __) => const ShimmerBox(height: 110, borderRadius: 12),
      );
    }
    if (_items.isEmpty) {
      return const Center(child: Text('No quizzes available.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final quiz = _items[i];
        final delayMs = kReduceMotion ? 0 : i * 40;
        return _QuizAppear(
          delayMs: delayMs,
          child: QuizCard(
            quiz: quiz,
            onStart: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => QuizAttemptScreen(quiz: quiz),
              ));
            },
          ),
        );
      },
    );
  }
}

class _QuizAppear extends StatefulWidget {
  const _QuizAppear({required this.child, this.delayMs = 0});
  final Widget child;
  final int delayMs;

  @override
  State<_QuizAppear> createState() => _QuizAppearState();
}

class _QuizAppearState extends State<_QuizAppear> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 240),
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

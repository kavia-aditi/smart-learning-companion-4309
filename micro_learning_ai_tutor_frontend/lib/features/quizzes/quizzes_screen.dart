import 'package:flutter/material.dart';

import '../../core/models/quiz.dart';
import '../../core/repositories/quiz_repository.dart';
import 'quiz_attempt_screen.dart';
import 'widgets/quiz_card.dart';

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
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) {
      return const Center(child: Text('No quizzes available.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final quiz = _items[i];
        return QuizCard(
          quiz: quiz,
          onStart: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => QuizAttemptScreen(quiz: quiz),
            ));
          },
        );
      },
    );
  }
}

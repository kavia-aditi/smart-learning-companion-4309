import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/quizzes_mock.dart';
import 'package:micro_learning_ai_tutor_frontend/state/quiz_progress_store.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/ocean_card.dart';

/// PUBLIC_INTERFACE
class QuizListScreen extends StatefulWidget {
  /// Lists all available quizzes as modern cards.
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  QuizProgressStore? _store;

  @override
  void initState() {
    super.initState();
    QuizProgressStore.create().then((s) {
      // After await: only update primitive state flags/refs
      setState(() {
        _store = s;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: MockQuizzesData.quizzes.length,
      itemBuilder: (context, index) {
        final quiz = MockQuizzesData.quizzes[index];
        final saved = _store?.getResult(quiz.id);
        final completed = saved?['completed'] == true;
        final lastScore = saved?['lastScore'] as int? ?? 0;
        final total = saved?['total'] as int? ?? quiz.questionCount;

        Color diffColor;
        switch (quiz.difficulty.toLowerCase()) {
          case 'easy':
            diffColor = const Color(0xFF10B981);
            break;
          case 'hard':
            diffColor = const Color(0xFFEF4444);
            break;
          default:
            diffColor = cs.tertiary;
        }

        final card = OceanCard.standard(
          leading: CircleAvatar(
            radius: 20,
            backgroundColor: cs.tertiary.withAlpha(24),
            child: Icon(Icons.quiz_outlined, color: cs.tertiary),
          ),
          title: quiz.title,
          subtitle: '${quiz.questionCount} questions • ${quiz.description}',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: diffColor.withAlpha(24),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: diffColor),
            ),
            child: Text(
              quiz.difficulty,
              style: TextStyle(
                color: diffColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuizDetailScreen(
                  quizId: quiz.id,
                  onCompleted: (score, total, durationMs) async {
                    final store = _store ?? await QuizProgressStore.create();
                    await store.saveResult(
                      quizId: quiz.id,
                      lastScore: score,
                      total: total,
                      completed: true,
                      durationMs: durationMs,
                    );
                    if (mounted) {
                      setState(() {}); // refresh card state
                    }
                  },
                ),
              ),
            );
          },
        );

        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              card,
              const SizedBox(height: 10),
              Row(
                children: [
                  if (completed)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: cs.onSecondaryContainer),
                      ),
                      child: Text(
                        'Last score: $lastScore/$total',
                        style: TextStyle(
                          color: cs.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    Text('Not completed', style: t.bodySmall),
                  const Spacer(),
                  SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuizDetailScreen(
                              quizId: quiz.id,
                              onCompleted: (score, total, durationMs) async {
                                final store =
                                    _store ?? await QuizProgressStore.create();
                                await store.saveResult(
                                  quizId: quiz.id,
                                  lastScore: score,
                                  total: total,
                                  completed: true,
                                  durationMs: durationMs,
                                );
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text('Start'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}



/// PUBLIC_INTERFACE
class QuizDetailScreen extends StatefulWidget {
  /// Runs a quiz by id from the mock catalog.
  const QuizDetailScreen({
    super.key,
    required this.quizId,
    required this.onCompleted,
  });

  final String quizId;

  /// Callback invoked when the quiz finishes with [score], [total], [durationMs].
  final void Function(int score, int total, int durationMs) onCompleted;

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  int _current = 0;
  int _correct = 0;
  late final DateTime _startedAt;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now().toUtc();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final quiz = MockQuizzesUtils.findById(widget.quizId);
    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('Quiz not found')),
      );
    }
    final q = quiz.questions[_current];

    return Scaffold(
      appBar: AppBar(title: Text(quiz.title)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${_current + 1} of ${quiz.questionCount}',
                style: t.bodySmall),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: (_current + 1) / quiz.questionCount,
              minHeight: 8,
              color: cs.primary,
              backgroundColor: const Color(0xFFF3F4F6),
            ),
            const SizedBox(height: 16),
            Text(q.text, style: t.titleMedium),
            const SizedBox(height: 12),
            ...List.generate(q.options.length, (i) {
              final opt = q.options[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: OutlinedButton(
                  onPressed: () {
                    final isRight = q.isCorrect(i);
                    if (isRight) _correct++;
                    if (_current + 1 >= quiz.questionCount) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => QuizResultScreen(
                            quizTitle: quiz.title,
                            score: _correct,
                            total: quiz.questionCount,
                            onDone: () {
                              final durationMs =
                                  DateTime.now().toUtc().difference(_startedAt).inMilliseconds;
                              widget.onCompleted(_correct, quiz.questionCount, durationMs);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    } else {
                      setState(() => _current++);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(opt, style: t.bodyLarge),
                  ),
                ),
              );
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

/// PUBLIC_INTERFACE
class QuizResultScreen extends StatelessWidget {
  /// Displays the final score and completion actions.
  const QuizResultScreen({
    super.key,
    required this.quizTitle,
    required this.score,
    required this.total,
    required this.onDone,
  });

  final String quizTitle;
  final int score;
  final int total;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(quizTitle)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quiz Completed', style: t.displaySmall),
            const SizedBox(height: 8),
            Text('Your score', style: t.bodySmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outline),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events_outlined, color: cs.secondary),
                  const SizedBox(width: 12),
                  Text('$score / $total', style: t.titleLarge),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onDone,
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}





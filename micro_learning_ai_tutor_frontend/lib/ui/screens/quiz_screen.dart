import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/progress_provider.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/quiz_provider.dart';

/// PUBLIC_INTERFACE
class QuizScreen extends ConsumerStatefulWidget {
  /// Minimal quiz runner over mock data, updates in-memory progress.
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _current = 0;
  int _correct = 0;

  @override
  Widget build(BuildContext context) {
    final quizzesAsync = ref.watch(quizzesForSelectedLessonProvider);
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: quizzesAsync.when(
        data: (quizzes) {
          if (quizzes.isEmpty) {
            return const Center(child: Text('No questions available'));
          }
          final q = quizzes[_current];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Question ${_current + 1} of ${quizzes.length}',
                    style: t.bodySmall),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (_current + 1) / quizzes.length,
                  minHeight: 8,
                  color: cs.primary,
                  backgroundColor: const Color(0xFFF3F4F6),
                ),
                const SizedBox(height: 16),
                Text(q.question, style: t.titleMedium),
                const SizedBox(height: 12),
                ...List.generate(q.options.length, (i) {
                  final opt = q.options[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: OutlinedButton(
                      onPressed: () {
                        final isRight = q.isCorrect(i);
                        if (isRight) _correct++;
                        // update step/score through controller
                        ref.read(progressControllerProvider.notifier)
                          ..updateStep(_current + 1)
                          ..updateScore(_correct / quizzes.length);
                        if (_current + 1 >= quizzes.length) {
                          ref.read(progressControllerProvider.notifier).markCompleted();
                          _showResultDialog(context, _correct, quizzes.length);
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Failed to load quiz: $e')),
      ),
    );
  }

  void _showResultDialog(BuildContext context, int correct, int total) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Completed'),
        content: Text('Score: $correct / $total'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

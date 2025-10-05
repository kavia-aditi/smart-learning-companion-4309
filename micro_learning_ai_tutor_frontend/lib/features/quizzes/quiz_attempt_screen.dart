import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/quiz.dart';
import '../../core/state/app_state.dart';
import '../../app.dart' show kReduceMotion;

/// PUBLIC_INTERFACE
class QuizAttemptScreen extends StatefulWidget {
  const QuizAttemptScreen({super.key, required this.quiz});

  final Quiz quiz;

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  int _index = 0;
  int _correct = 0;
  int? _selected;

  void _submit() {
    final q = widget.quiz.questions[_index];
    final isCorrect = _selected == q.correctIndex;
    if (isCorrect) _correct += 1;

    final explanation = q.explanation ?? (isCorrect ? 'Correct! Great job.' : 'Not quite. Try reviewing this concept.');

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Correct' : 'Incorrect'),
        content: Text(explanation),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _selected = null;
                _index += 1;
              });
              if (_index >= widget.quiz.questions.length) {
                // Finish
                context.read<AppState>().saveQuizScore(widget.quiz.id, _correct);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Quiz complete! Score: $_correct/${widget.quiz.questions.length}')),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.quiz.questions[_index];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.quiz.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: Column(
            key: ValueKey('q-$_index'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Question ${_index + 1} of ${widget.quiz.questions.length}', style: theme.textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(q.prompt, style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              ...List.generate(q.options.length, (i) {
                final opt = q.options[i];
                return RadioListTile<int>(
                  value: i,
                  groupValue: _selected,
                  onChanged: (val) => setState(() => _selected = val),
                  title: Text(opt),
                );
              }),
              const Spacer(),
              ElevatedButton(
                onPressed: _selected == null ? null : _submit,
                child: const Text('Submit answer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

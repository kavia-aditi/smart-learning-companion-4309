import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/analytics_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/quizzes/quiz_list_screen.dart';

/// PUBLIC_INTERFACE
class QuizzesScreen extends StatelessWidget {
  /// Quizzes tab that shows the full catalog of quizzes with Analytics action.
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
        actions: [
          IconButton(
            tooltip: 'Analytics',
            icon: const Icon(Icons.insights_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              );
            },
          ),
        ],
      ),
      body: const QuizListScreen(),
    );
  }
}

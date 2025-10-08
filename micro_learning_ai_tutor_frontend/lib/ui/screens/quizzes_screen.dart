import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/quizzes/quiz_list_screen.dart';

/// PUBLIC_INTERFACE
class QuizzesScreen extends StatelessWidget {
  /// Quizzes tab that shows the full catalog of quizzes.
  const QuizzesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuizListScreen();
  }
}

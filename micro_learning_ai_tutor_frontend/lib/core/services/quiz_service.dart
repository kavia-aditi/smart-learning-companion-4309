import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/quiz.dart';

/// PUBLIC_INTERFACE
abstract class QuizService {
  /// Fetch available quizzes.
  Future<List<Quiz>> fetchQuizzes();

  /// Optional: submit quiz attempt, returns score; not implemented yet.
  Future<void> submitQuizAttempt(String quizId, Map<String, int> answers);
}

/// Mock quiz service loading from bundled JSON.
class MockQuizService implements QuizService {
  @override
  Future<List<Quiz>> fetchQuizzes() async {
    final raw = await rootBundle.loadString('assets/mock/quizzes.json');
    final data = jsonDecode(raw) as List<dynamic>;
    return data.map((e) => Quiz.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> submitQuizAttempt(String quizId, Map<String, int> answers) async {
    // Future API call placeholder.
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

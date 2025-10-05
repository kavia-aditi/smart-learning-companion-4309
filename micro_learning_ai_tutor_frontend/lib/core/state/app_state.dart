import 'package:flutter/foundation.dart';

/// PUBLIC_INTERFACE
class AppState extends ChangeNotifier {
  /// In-memory progress for lessons: lessonId -> percent (0..100)
  final Map<String, int> lessonProgress = {};

  /// In-memory quiz attempts: quizId -> correct count
  final Map<String, int> quizScores = {};

  void updateLessonProgress(String lessonId, int percent) {
    final p = percent.clamp(0, 100);
    lessonProgress[lessonId] = p;
    notifyListeners();
  }

  void saveQuizScore(String quizId, int correct) {
    quizScores[quizId] = correct;
    notifyListeners();
  }
}

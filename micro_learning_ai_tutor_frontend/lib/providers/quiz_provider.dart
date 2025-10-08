import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/lessons_provider.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/mock_quiz_repository.dart';

final _quizRepoProvider = Provider<MockQuizRepository>((ref) {
  return MockQuizRepository();
});

/// PUBLIC_INTERFACE
final quizzesForSelectedLessonProvider =
    FutureProvider<List<Quiz>>((ref) async {
  final lessonId = ref.watch(selectedLessonIdProvider);
  final repo = ref.watch(_quizRepoProvider);
  if (lessonId == null) return <Quiz>[];
  return repo.getQuizzesForLesson(lessonId);
});

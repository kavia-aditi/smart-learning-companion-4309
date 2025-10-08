import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/mock_quiz_repository.dart';

final _quizRepoProvider = Provider<MockQuizRepository>((ref) {
  return MockQuizRepository();
});

/// PUBLIC_INTERFACE
/// Provides the full list of quizzes for the Quizzes tab.
final quizCatalogProvider = FutureProvider<List<QuizCatalog>>((ref) async {
  final repo = ref.watch(_quizRepoProvider);
  return repo.getAllQuizzes();
});

/// PUBLIC_INTERFACE
/// Retrieves a single quiz by id.
final quizByIdProvider =
    FutureProvider.family<QuizCatalog?, String>((ref, id) async {
  final repo = ref.watch(_quizRepoProvider);
  return repo.getQuizById(id);
});

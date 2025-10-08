import 'package:micro_learning_ai_tutor_frontend/lib_fix.dart' show inlineFuture;
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/quizzes_mock.dart';
import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';

/// PUBLIC_INTERFACE
class MockQuizRepository {
  /// Returns the full catalog of quizzes.
  Future<List<QuizCatalog>> getAllQuizzes() =>
      inlineFuture(MockQuizzesData.quizzes);

  /// Returns a single quiz by id if found.
  Future<QuizCatalog?> getQuizById(String id) => inlineFuture(
        MockQuizzesData.quizzes.firstWhere(
          (q) => q.id == id,
          orElse: () => MockQuizzesData.quizzes.first,
        ),
      );
}

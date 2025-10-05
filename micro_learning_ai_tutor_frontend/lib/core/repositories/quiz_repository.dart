import '../models/quiz.dart';
import '../services/quiz_service.dart';

/// PUBLIC_INTERFACE
class QuizRepository {
  QuizRepository({QuizService? service}) : _service = service ?? MockQuizService();

  final QuizService _service;

  Future<List<Quiz>> list() => _service.fetchQuizzes();

  Future<void> submit(String quizId, Map<String, int> answers) => _service.submitQuizAttempt(quizId, answers);
}

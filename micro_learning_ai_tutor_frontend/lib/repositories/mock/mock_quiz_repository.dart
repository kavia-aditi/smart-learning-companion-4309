import 'package:micro_learning_ai_tutor_frontend/lib_fix.dart' show inlineFuture;
import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';

/// PUBLIC_INTERFACE
class MockQuizRepository {
  /// Returns quizzes for a given lesson id.
  Future<List<Quiz>> getQuizzesForLesson(String lessonId) =>
      inlineFuture(_sampleQuizzes.where((q) => q.lessonId == lessonId).toList());

  static final List<Quiz> _sampleQuizzes = <Quiz>[
    Quiz(
      id: 'q1',
      lessonId: 'lsn_war2',
      question: 'In which year did World War II begin?',
      options: ['1914', '1939', '1945', '1963'],
      correctIndex: 1,
      explanation: 'WWII began in 1939 with the invasion of Poland.',
    ),
    Quiz(
      id: 'q2',
      lessonId: 'lsn_photosyn',
      question: 'Where does photosynthesis primarily occur?',
      options: ['Mitochondria', 'Nucleus', 'Chloroplasts', 'Ribosomes'],
      correctIndex: 2,
      explanation: 'Chloroplasts contain chlorophyll to absorb light energy.',
    ),
    Quiz(
      id: 'q3',
      lessonId: 'lsn_algebra',
      question: 'Solve for x: x + 3 = 5',
      options: ['1', '2', '3', '5'],
      correctIndex: 1,
      explanation: 'Subtract 3 from both sides to get x = 2.',
    ),
  ];
}

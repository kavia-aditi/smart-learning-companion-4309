import 'package:micro_learning_ai_tutor_frontend/lib_fix.dart' show inlineFuture;
import 'package:micro_learning_ai_tutor_frontend/models/recommendation.dart';

/// PUBLIC_INTERFACE
class MockRecommendationsRepository {
  /// Returns mock recommendations.
  Future<List<Recommendation>> getRecommendations() =>
      inlineFuture(_sampleRecs);

  static final List<Recommendation> _sampleRecs = <Recommendation>[
    Recommendation(
      id: 'rec1',
      lessonId: 'lsn_photosyn',
      reason: 'You’ve engaged with Science topics recently',
      confidence: 0.86,
    ),
    Recommendation(
      id: 'rec2',
      lessonId: 'lsn_algebra',
      reason: 'Strengthen your Math fundamentals',
      confidence: 0.78,
    ),
  ];
}

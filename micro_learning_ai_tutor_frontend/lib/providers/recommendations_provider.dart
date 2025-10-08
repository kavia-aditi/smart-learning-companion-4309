import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/models/recommendation.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/mock_recommendations_repository.dart';

final _recsRepoProvider = Provider<MockRecommendationsRepository>((ref) {
  return MockRecommendationsRepository();
});

/// PUBLIC_INTERFACE
final recommendationsProvider =
    FutureProvider<List<Recommendation>>((ref) async {
  final repo = ref.watch(_recsRepoProvider);
  return repo.getRecommendations();
});

import 'package:micro_learning_ai_tutor_frontend/services/api_client.dart';

/// Service for submitting or updating user progress.
class ProgressService {
  ProgressService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  // PUBLIC_INTERFACE
  /// Upserts user progress for a lesson/quiz.
  /// Returns backend response map (e.g., { success: true, ... }).
  Future<Map<String, dynamic>> upsertProgress({
    required String userId,
    required String lessonId,
    required num score,
  }) async {
    final payload = {
      'userId': userId,
      'lessonId': lessonId,
      'score': score,
    };
    final data = await _client.post('/api/progress', payload);
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {'success': true, 'data': data};
  }
}

import 'package:micro_learning_ai_tutor_frontend/services/api_client.dart';

/// Service for fetching quizzes from the backend.
class QuizzesService {
  QuizzesService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  // PUBLIC_INTERFACE
  /// Returns a list of quizzes as dynamic maps.
  Future<List<Map<String, dynamic>>> listQuizzes() async {
    final data = await _client.get('/api/quizzes');
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map && data['quizzes'] is List) {
      return (data['quizzes'] as List).cast<Map<String, dynamic>>();
    }
    return const [];
  }
}

import 'package:micro_learning_ai_tutor_frontend/services/api_client.dart';

/// Service for fetching lessons from the backend.
class LessonsService {
  LessonsService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  // PUBLIC_INTERFACE
  /// Returns a list of lessons as dynamic maps to keep it backend-schema agnostic.
  Future<List<Map<String, dynamic>>> listLessons() async {
    final data = await _client.get('/api/lessons');
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map && data['lessons'] is List) {
      return (data['lessons'] as List).cast<Map<String, dynamic>>();
    }
    return const [];
  }
}

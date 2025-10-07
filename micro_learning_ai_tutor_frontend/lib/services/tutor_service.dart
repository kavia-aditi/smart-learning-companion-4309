import 'package:micro_learning_ai_tutor_frontend/services/api_client.dart';

/// Service to interact with the AI Tutor chat endpoint.
class TutorService {
  TutorService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  // PUBLIC_INTERFACE
  /// Sends a chat message to the tutor with optional history and userId.
  /// Expects backend to return an assistant message or object including text/content.
  Future<Map<String, dynamic>> chat({
    required String message,
    List<Map<String, String>>? history,
    String? userId,
  }) async {
    final payload = <String, dynamic>{
      'message': message,
      if (history != null && history.isNotEmpty) 'history': history,
      if (userId != null) 'userId': userId,
    };
    final data = await _client.post('/api/tutor/chat', payload);
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {'response': data};
  }
}

/// PUBLIC_INTERFACE
abstract class TutorService {
  /// Sends a user question to the AI tutor and returns a response.
  Future<String> askTutor(String question);
}

/// Mock implementation with canned responses.
class MockTutorService implements TutorService {
  @override
  Future<String> askTutor(String question) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return "Great question! Let's break it down into a quick, 2-minute concept: $question";
  }
}

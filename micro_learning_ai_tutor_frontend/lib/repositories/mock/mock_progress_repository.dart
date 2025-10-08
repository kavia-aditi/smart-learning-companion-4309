import 'package:micro_learning_ai_tutor_frontend/lib_fix.dart' show inlineFuture;
import 'package:micro_learning_ai_tutor_frontend/models/progress.dart';

/// PUBLIC_INTERFACE
class MockProgressRepository {
  /// In-memory progress store keyed by lessonId.
  final Map<String, Progress> _store = {};

  /// Returns the progress for a lesson if any.
  Future<Progress?> getProgressForLesson(String lessonId) =>
      inlineFuture(_store[lessonId]);

  /// Create or update a progress entry.
  Future<void> upsertProgress(Progress progress) async {
    _store[progress.lessonId] = progress.copyWith(lastUpdated: DateTime.now());
  }
}

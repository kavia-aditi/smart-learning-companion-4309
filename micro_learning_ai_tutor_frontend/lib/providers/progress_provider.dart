import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/models/progress.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/lessons_provider.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/mock_progress_repository.dart';

final _progressRepoProvider = Provider<MockProgressRepository>((ref) {
  return MockProgressRepository();
});

/// PUBLIC_INTERFACE
final progressForSelectedLessonProvider =
    FutureProvider<Progress?>((ref) async {
  final repo = ref.watch(_progressRepoProvider);
  final lessonId = ref.watch(selectedLessonIdProvider);
  if (lessonId == null) return null;
  return repo.getProgressForLesson(lessonId);
});

/// PUBLIC_INTERFACE
class ProgressController extends Notifier<Progress?> {
  @override
  Progress? build() {
    // initialize from repository if a lesson is selected
    final lessonId = ref.read(selectedLessonIdProvider);
    if (lessonId == null) return null;
    // Notifier cannot be async, so just null initial; UI should listen to progressForSelectedLessonProvider as source of truth
    return null;
  }

  /// Mark current lesson as completed.
  Future<void> markCompleted() async {
    final repo = ref.read(_progressRepoProvider);
    final lessonId = ref.read(selectedLessonIdProvider);
    if (lessonId == null) return;
    final current = ref.read(progressForSelectedLessonProvider).value ??
        Progress(
          userId: null,
          lessonId: lessonId,
          completed: false,
          currentStep: 0,
          score: null,
          lastUpdated: DateTime.now(),
        );
    final updated = current.copyWith(completed: true, lastUpdated: DateTime.now());
    await repo.upsertProgress(updated);
    // no direct stateful widget ops; just refresh provider
    ref.invalidate(progressForSelectedLessonProvider);
  }

  /// Update numeric score (0..1 or raw value).
  Future<void> updateScore(double score) async {
    final repo = ref.read(_progressRepoProvider);
    final lessonId = ref.read(selectedLessonIdProvider);
    if (lessonId == null) return;
    final current = ref.read(progressForSelectedLessonProvider).value ??
        Progress(
          userId: null,
          lessonId: lessonId,
          completed: false,
          currentStep: 0,
          score: null,
          lastUpdated: DateTime.now(),
        );
    final updated = current.copyWith(score: score, lastUpdated: DateTime.now());
    await repo.upsertProgress(updated);
    ref.invalidate(progressForSelectedLessonProvider);
  }

  /// Update the current step index.
  Future<void> updateStep(int step) async {
    final repo = ref.read(_progressRepoProvider);
    final lessonId = ref.read(selectedLessonIdProvider);
    if (lessonId == null) return;
    final current = ref.read(progressForSelectedLessonProvider).value ??
        Progress(
          userId: null,
          lessonId: lessonId,
          completed: false,
          currentStep: 0,
          score: null,
          lastUpdated: DateTime.now(),
        );
    final updated = current.copyWith(currentStep: step, lastUpdated: DateTime.now());
    await repo.upsertProgress(updated);
    ref.invalidate(progressForSelectedLessonProvider);
  }
}

final progressControllerProvider =
    NotifierProvider<ProgressController, Progress?>(ProgressController.new);

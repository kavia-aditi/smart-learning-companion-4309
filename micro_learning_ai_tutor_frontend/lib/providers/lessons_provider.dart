import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/models/lesson.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/mock_lessons_repository.dart';

final _lessonsRepoProvider = Provider<MockLessonsRepository>((ref) {
  return MockLessonsRepository();
});

/// PUBLIC_INTERFACE
final lessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final repo = ref.watch(_lessonsRepoProvider);
  return repo.getLessons();
});

/// PUBLIC_INTERFACE
final selectedLessonIdProvider = StateProvider<String?>((ref) => null);

/// PUBLIC_INTERFACE
final selectedLessonProvider = Provider<Lesson?>((ref) {
  final id = ref.watch(selectedLessonIdProvider);
  final asyncLessons = ref.watch(lessonsProvider);

  return asyncLessons.maybeWhen(
    data: (list) => list.where((l) => l.id == id).cast<Lesson?>().firstOrNull,
    orElse: () => null,
  );
});

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

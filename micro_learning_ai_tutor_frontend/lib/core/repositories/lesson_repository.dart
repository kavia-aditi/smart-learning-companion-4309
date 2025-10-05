import '../models/lesson.dart';
import '../services/lesson_service.dart';

/// PUBLIC_INTERFACE
class LessonRepository {
  LessonRepository({LessonService? service}) : _service = service ?? MockLessonService();

  final LessonService _service;

  Future<List<Lesson>> list() => _service.fetchLessons();

  Future<Lesson> getById(String id) => _service.getLessonById(id);
}

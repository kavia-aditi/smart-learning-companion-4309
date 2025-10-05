import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/lesson.dart';

/// PUBLIC_INTERFACE
abstract class LessonService {
  /// Fetch lessons, optionally from API in future.
  Future<List<Lesson>> fetchLessons();

  /// Placeholder for future backend integration.
  Future<Lesson> getLessonById(String id);
}

/// Mock implementation loading from local assets.
class MockLessonService implements LessonService {
  @override
  Future<List<Lesson>> fetchLessons() async {
    final raw = await rootBundle.loadString('assets/mock/lessons.json');
    final data = jsonDecode(raw) as List<dynamic>;
    return data.map((e) => Lesson.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<Lesson> getLessonById(String id) async {
    final all = await fetchLessons();
    return all.firstWhere((l) => l.id == id, orElse: () => all.first);
  }
}

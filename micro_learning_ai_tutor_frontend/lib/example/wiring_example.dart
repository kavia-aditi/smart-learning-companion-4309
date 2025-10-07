import 'dart:developer' as dev;

import 'package:micro_learning_ai_tutor_frontend/services/lessons_service.dart';
import 'package:micro_learning_ai_tutor_frontend/services/tutor_service.dart';

/// Demonstrates how to use the services without wiring into the app UI.
/// You can call runWiringExample() from main() during development to verify connectivity.
///
/// Note: Do not call this in production; it's for manual verification only.
Future<void> runWiringExample() async {
  final lessonsService = LessonsService();
  final tutorService = TutorService();

  try {
    final lessons = await lessonsService.listLessons();
    dev.log('Fetched lessons: count=${lessons.length}');
    if (lessons.isNotEmpty) {
      dev.log('First lesson: ${lessons.first}');
    }
  } catch (e, st) {
    dev.log('Error fetching lessons: $e', stackTrace: st);
  }

  try {
    final chatRes = await tutorService.chat(
      message: 'Hello tutor! Can you give me a tip about micro-learning?',
      history: const [
        {'role': 'system', 'content': 'You are a helpful micro-learning tutor.'}
      ],
    );
    dev.log('Tutor chat response: $chatRes');
  } catch (e, st) {
    dev.log('Error chatting with tutor: $e', stackTrace: st);
  }
}

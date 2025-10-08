import 'dart:math';

import 'package:micro_learning_ai_tutor_frontend/models/quiz_attempt.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/quizzes_mock.dart';
import 'package:micro_learning_ai_tutor_frontend/state/quiz_progress_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PUBLIC_INTERFACE
Future<void> seedQuizAttemptsIfNeeded() async {
  /// Seeds a few synthetic attempts for each quiz to make analytics meaningful
  /// on first run. This is idempotent via a SharedPreferences flag.
  ///
  /// - Adds 2–4 attempts per quiz
  /// - Timestamps randomized over last 14 days
  /// - Scores and durations varied
  /// - Uses only local storage; no networking
  final prefs = await SharedPreferences.getInstance();
  const flagKey = 'seeded_v1';
  final alreadySeeded = prefs.getBool(flagKey) ?? false;
  if (alreadySeeded) return;

  final store = await QuizProgressStore.create();
  final rnd = Random(42);
  final now = DateTime.now().toUtc();

  for (final quiz in MockQuizzesData.quizzes) {
    // If there are existing attempts, skip seeding for this quiz to avoid duplicates.
    final existing = store.getAttempts(quiz.id);
    if (existing.isNotEmpty) {
      continue;
    }

    final toCreate = 2 + rnd.nextInt(3); // 2..4 attempts
    for (int i = 0; i < toCreate; i++) {
      final daysAgo = rnd.nextInt(14); // 0..13 days back
      final when = now.subtract(Duration(days: daysAgo, hours: rnd.nextInt(23), minutes: rnd.nextInt(59)));
      final total = quiz.questionCount;
      // create reasonable scores within 0..total with some variance
      final score = max(0, min(total, (total * (0.4 + rnd.nextDouble() * 0.6)).round()));
      // durations between 20s and 4min
      final durationMs = (20000 + rnd.nextInt(200000)).toInt();

      await store.appendAttempt(QuizAttempt(
        quizId: quiz.id,
        score: score,
        total: total,
        timestamp: when,
        durationMs: durationMs,
      ));
    }

    // Also backfill the simple summary result for UI tiles if they use it
    final last = store.getLastAttempt(quiz.id);
    if (last != null) {
      await prefs.setString(
        'quiz_progress_${quiz.id}',
        // minimal legacy summary JSON
        '{"lastScore": ${last.score}, "total": ${last.total}, "completed": true, "updatedAt": "${last.timestamp.toIso8601String()}"}',
      );
    }
  }

  await prefs.setBool(flagKey, true);
}

import 'dart:convert';

import 'package:micro_learning_ai_tutor_frontend/models/quiz_attempt.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PUBLIC_INTERFACE
class QuizProgressStore {
  /// Stores and retrieves per-quiz progress locally using shared_preferences.
  QuizProgressStore(this._prefs);

  final SharedPreferences _prefs;

  static const _keyPrefix = 'quiz_progress_';
  static const _attemptsKeyPrefix = 'quiz_attempts_';

  /// PUBLIC_INTERFACE
  /// Creates an instance with SharedPreferences asynchronously.
  static Future<QuizProgressStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return QuizProgressStore(prefs);
  }

  /// PUBLIC_INTERFACE
  /// Save the last score and completion state for a quiz (legacy summary).
  /// Also appends an attempt record to the attempts list.
  Future<void> saveResult({
    required String quizId,
    required int lastScore,
    required int total,
    required bool completed,
    int? durationMs,
  }) async {
    final data = {
      'lastScore': lastScore,
      'total': total,
      'completed': completed,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString('$_keyPrefix$quizId', jsonEncode(data));

    // Append attempt to historical store
    final attempt = QuizAttempt(
      quizId: quizId,
      score: lastScore,
      total: total,
      timestamp: DateTime.now().toUtc(),
      durationMs: durationMs ?? 0,
    );
    await appendAttempt(attempt);
  }

  /// PUBLIC_INTERFACE
  /// Read saved result summary for a quiz (may be migrated from attempts).
  Map<String, dynamic>? getResult(String quizId) {
    final str = _prefs.getString('$_keyPrefix$quizId');
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// PUBLIC_INTERFACE
  /// Returns all attempts for a given quiz id.
  List<QuizAttempt> getAttempts(String quizId) {
    final str = _prefs.getString('$_attemptsKeyPrefix$quizId');
    if (str == null) {
      // Attempt migration if legacy summary exists
      final legacy = getResult(quizId);
      if (legacy != null && legacy['lastScore'] != null && legacy['total'] != null) {
        final migrated = [
          QuizAttempt(
            quizId: quizId,
            score: (legacy['lastScore'] as num).toInt(),
            total: (legacy['total'] as num).toInt(),
            timestamp: DateTime.tryParse(legacy['updatedAt'] as String? ?? '')?.toUtc() ??
                DateTime.now().toUtc(),
            durationMs: 0,
          ),
        ];
        _prefs.setString('$_attemptsKeyPrefix$quizId', QuizAttempt.encodeList(migrated));
        return migrated;
      }
      return <QuizAttempt>[];
    }
    try {
      return QuizAttempt.decodeList(str);
    } catch (_) {
      return <QuizAttempt>[];
    }
  }

  /// PUBLIC_INTERFACE
  /// Append a single attempt to the stored list.
  Future<void> appendAttempt(QuizAttempt attempt) async {
    final list = getAttempts(attempt.quizId);
    list.add(attempt);
    await _prefs.setString('$_attemptsKeyPrefix${attempt.quizId}', QuizAttempt.encodeList(list));
  }

  /// PUBLIC_INTERFACE
  /// Returns the latest attempt for a quiz if any.
  QuizAttempt? getLastAttempt(String quizId) {
    final attempts = getAttempts(quizId);
    if (attempts.isEmpty) return null;
    attempts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return attempts.first;
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// PUBLIC_INTERFACE
class QuizProgressStore {
  /// Stores and retrieves per-quiz progress locally using shared_preferences.
  QuizProgressStore(this._prefs);

  final SharedPreferences _prefs;

  static const _keyPrefix = 'quiz_progress_';

  /// PUBLIC_INTERFACE
  /// Creates an instance with SharedPreferences asynchronously.
  static Future<QuizProgressStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return QuizProgressStore(prefs);
  }

  /// PUBLIC_INTERFACE
  /// Save the last score and completion state for a quiz.
  Future<void> saveResult({
    required String quizId,
    required int lastScore,
    required int total,
    required bool completed,
  }) async {
    final data = {
      'lastScore': lastScore,
      'total': total,
      'completed': completed,
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString('$_keyPrefix$quizId', jsonEncode(data));
  }

  /// PUBLIC_INTERFACE
  /// Read saved result summary for a quiz.
  Map<String, dynamic>? getResult(String quizId) {
    final str = _prefs.getString('$_keyPrefix$quizId');
    if (str == null) return null;
    try {
      return jsonDecode(str) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}

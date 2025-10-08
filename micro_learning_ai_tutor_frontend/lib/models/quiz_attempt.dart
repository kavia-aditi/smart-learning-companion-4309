import 'dart:convert';

/// PUBLIC_INTERFACE
class QuizAttempt {
  /// Represents a single quiz attempt with minimal analytics data.
  QuizAttempt({
    required this.quizId,
    required this.score,
    required this.total,
    required this.timestamp,
    required this.durationMs,
  });

  /// Quiz identifier.
  final String quizId;

  /// Number of correct answers.
  final int score;

  /// Total questions.
  final int total;

  /// Completion timestamp (UTC).
  final DateTime timestamp;

  /// Duration in milliseconds.
  final int durationMs;

  /// Score as 0..100 percentage.
  double get percent => total == 0 ? 0 : (score / total) * 100.0;

  Map<String, dynamic> toJson() => {
        'quizId': quizId,
        'score': score,
        'total': total,
        'timestamp': timestamp.toIso8601String(),
        'durationMs': durationMs,
      };

  /// PUBLIC_INTERFACE
  static QuizAttempt fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      quizId: json['quizId'] as String,
      score: json['score'] as int,
      total: json['total'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
    );
  }

  /// PUBLIC_INTERFACE
  static List<QuizAttempt> decodeList(String jsonStr) {
    final list = json.decode(jsonStr) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map(QuizAttempt.fromJson)
        .toList();
  }

  /// PUBLIC_INTERFACE
  static String encodeList(List<QuizAttempt> items) {
    return json.encode(items.map((a) => a.toJson()).toList());
  }
}

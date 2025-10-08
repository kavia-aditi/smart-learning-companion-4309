import 'dart:convert';

import 'package:micro_learning_ai_tutor_frontend/models/quiz_attempt.dart';

/// PUBLIC_INTERFACE
String analyticsToCsv({
  required List<QuizAttempt> attempts,
  required Map<String, dynamic> kpis,
  required List<Map<String, dynamic>> perQuiz,
}) {
  // CSV header
  final buffer = StringBuffer();
  buffer.writeln('quizId,quizTitle,category,attemptTimestampISO,score,durationMs');

  // Build a lookup for quiz metadata if present in perQuiz
  final Map<String, Map<String, dynamic>> quizMetaById = {};
  for (final m in perQuiz) {
    final id = m['quizId']?.toString();
    if (id != null) quizMetaById[id] = m;
  }

  // Helper to escape CSV fields with commas/quotes/newlines
  String esc(dynamic value) {
    final s = (value ?? '').toString();
    final needsQuote = s.contains(',') || s.contains('"') || s.contains('\n') || s.contains('\r');
    if (!needsQuote) return s;
    final doubled = s.replaceAll('"', '""');
    return '"$doubled"';
    // RFC4180 style escaping
  }

  for (final a in attempts) {
    final meta = quizMetaById[a.quizId];
    final quizTitle = meta?['quizTitle'] ?? '';
    final category = meta?['category'] ?? '';
    buffer.writeln([
      esc(a.quizId),
      esc(quizTitle),
      esc(category),
      esc(a.timestamp.toUtc().toIso8601String()),
      esc(a.score.toString()),
      esc(a.durationMs.toString()),
    ].join(','));
  }

  return buffer.toString();
}

/// PUBLIC_INTERFACE
String analyticsToJson({
  required List<QuizAttempt> attempts,
  required Map<String, dynamic> kpis,
  required List<Map<String, dynamic>> perQuiz,
  Map<String, dynamic>? filters,
}) {
  final payload = <String, dynamic>{
    'meta': {
      'generatedAt': DateTime.now().toUtc().toIso8601String(),
      'filters': filters ?? {},
    },
    'kpis': kpis,
    'perQuiz': perQuiz,
    'attempts': attempts.map((a) {
      return {
        'quizId': a.quizId,
        'attemptTimestampISO': a.timestamp.toUtc().toIso8601String(),
        'score': a.score,
        'total': a.total,
        'percent': a.percent,
        'durationMs': a.durationMs,
      };
    }).toList(),
  };

  return const JsonEncoder.withIndent('  ').convert(payload);
}

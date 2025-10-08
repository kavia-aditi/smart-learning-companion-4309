import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';

import 'package:micro_learning_ai_tutor_frontend/repositories/mock/mock_quiz_repository.dart';
import 'package:micro_learning_ai_tutor_frontend/state/quiz_progress_store.dart';

/// Basic dependency providers
final _quizRepoProvider = Provider<MockQuizRepository>((ref) => MockQuizRepository());

/// PUBLIC_INTERFACE
/// Provides a singleton store instance for analytics access.
final quizProgressStoreProvider = FutureProvider<QuizProgressStore>((ref) async {
  return QuizProgressStore.create();
});

/// Analytics models
class QuizKpis {
  QuizKpis({
    required this.totalTaken,
    required this.avgScorePct,
    required this.bestScorePct,
    required this.completionRatePct,
    required this.last7DaysCount,
  });

  final int totalTaken;
  final double avgScorePct;
  final double bestScorePct;
  final double completionRatePct;
  final int last7DaysCount;
}

class PerQuizStat {
  PerQuizStat({
    required this.quiz,
    required this.attempts,
    required this.lastScorePct,
    required this.bestScorePct,
    required this.avgScorePct,
    required this.completedOnce,
  });

  final QuizCatalog quiz;
  final int attempts;
  final double lastScorePct;
  final double bestScorePct;
  final double avgScorePct;
  final bool completedOnce;
}

class QuizAnalytics {
  QuizAnalytics({required this.kpis, required this.perQuiz});
  final QuizKpis kpis;
  final List<PerQuizStat> perQuiz;
}

/// PUBLIC_INTERFACE
/// Computes analytics from stored attempts and quiz catalog.
final quizAnalyticsProvider = FutureProvider<QuizAnalytics>((ref) async {
  final repo = ref.watch(_quizRepoProvider);
  final quizzes = await repo.getAllQuizzes();
  final store = await ref.watch(quizProgressStoreProvider.future);

  // Gather attempts per quiz
  final now = DateTime.now().toUtc();
  int totalAttempts = 0;
  int completedCount = 0;
  double sumPct = 0;
  double bestPct = 0;
  int last7 = 0;

  final stats = <PerQuizStat>[];
  for (final q in quizzes) {
    final attempts = store.getAttempts(q.id);
    attempts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    totalAttempts += attempts.length;

    double avg = 0;
    double best = 0;
    double last = 0;
    if (attempts.isNotEmpty) {
      final pcts = attempts.map((a) => a.percent).toList();
      sumPct += pcts.fold(0.0, (a, b) => a + b);
      best = pcts.reduce((a, b) => a > b ? a : b);
      bestPct = bestPct < best ? best : bestPct;
      last = attempts.first.percent;
      avg = pcts.reduce((a, b) => a + b) / pcts.length;
      completedCount += 1;
    }
    // streak/last7 days
    final recentCount = attempts
        .where((a) => now.difference(a.timestamp).inDays <= 6) // include today + 6 days back
        .length;
    last7 += recentCount;

    stats.add(PerQuizStat(
      quiz: q,
      attempts: attempts.length,
      lastScorePct: last,
      bestScorePct: best,
      avgScorePct: avg,
      completedOnce: attempts.isNotEmpty,
    ));
  }

  final quizzesCount = quizzes.isEmpty ? 1 : quizzes.length; // avoid div-by-zero
  final kpis = QuizKpis(
    totalTaken: totalAttempts,
    avgScorePct: totalAttempts == 0 ? 0 : (sumPct / totalAttempts),
    bestScorePct: bestPct,
    completionRatePct: (completedCount / quizzesCount) * 100.0,
    last7DaysCount: last7,
  );

  return QuizAnalytics(kpis: kpis, perQuiz: stats);
});

/// PUBLIC_INTERFACE
/// Force refresh analytics (e.g., after saving attempt).
class QuizAnalyticsRefresher extends AutoDisposeNotifier<int> {
  @override
  int build() => 0;

  void refresh() {
    state++;
  }
}

final quizAnalyticsRefresherProvider =
    AutoDisposeNotifierProvider<QuizAnalyticsRefresher, int>(QuizAnalyticsRefresher.new);

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';
import 'package:micro_learning_ai_tutor_frontend/repositories/mock/mock_quiz_repository.dart';
import 'package:micro_learning_ai_tutor_frontend/state/quiz_progress_store.dart';

/// Basic dependency providers
final _quizRepoProvider =
    Provider<MockQuizRepository>((ref) => MockQuizRepository());

/// PUBLIC_INTERFACE
/// Provides a singleton store instance for analytics access.
final quizProgressStoreProvider = FutureProvider<QuizProgressStore>((ref) async {
  return QuizProgressStore.create();
});

/// Filter model used by analytics
class AnalyticsFilter {
  const AnalyticsFilter({
    required this.start,
    required this.end,
    this.category, // null = All
  });

  final DateTime start; // inclusive
  final DateTime end; // inclusive
  final String? category;

  @override
  bool operator ==(Object other) {
    return other is AnalyticsFilter &&
        other.start.millisecondsSinceEpoch == start.millisecondsSinceEpoch &&
        other.end.millisecondsSinceEpoch == end.millisecondsSinceEpoch &&
        other.category == category;
  }

  @override
  int get hashCode =>
      Object.hash(start.millisecondsSinceEpoch, end.millisecondsSinceEpoch, category);
}

/// Analytics models
class QuizKpis {
  QuizKpis({
    required this.totalTaken,
    required this.avgScorePct,
    required this.bestScorePct,
    required this.completionRatePct,
    required this.recentAttemptsCount,
  });

  final int totalTaken;
  final double avgScorePct;
  final double bestScorePct;
  final double completionRatePct;
  final int recentAttemptsCount;
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
/// A notifier that holds the current analytics filter in state.
/// Filters are not persisted across app restarts.
class AnalyticsFilterNotifier extends AutoDisposeNotifier<AnalyticsFilter> {
  @override
  AnalyticsFilter build() {
    final now = DateTime.now().toUtc();
    final start = now.subtract(const Duration(days: 30));
    return AnalyticsFilter(start: _startOfDay(start), end: _endOfDay(now));
  }

  // PUBLIC_INTERFACE
  void setPresetDays(int days) {
    final now = DateTime.now().toUtc();
    final start = _startOfDay(now.subtract(Duration(days: days - 1)));
    final end = _endOfDay(now);
    state = AnalyticsFilter(start: start, end: end, category: state.category);
  }

  // PUBLIC_INTERFACE
  void setCustomRange(DateTime start, DateTime end) {
    state = AnalyticsFilter(start: _startOfDay(start.toUtc()), end: _endOfDay(end.toUtc()), category: state.category);
  }

  // PUBLIC_INTERFACE
  /// Apply a precomputed [start]/[end] range (UTC or local) without changing persistence.
  /// This enables quick preset updates like "This week" or "This month".
  void applyRange(DateTime start, DateTime end) {
    final s = _startOfDay(start.toUtc());
    final e = _endOfDay(end.toUtc());
    state = AnalyticsFilter(start: s, end: e, category: state.category);
  }

  // PUBLIC_INTERFACE
  void setCategory(String? category) {
    state = AnalyticsFilter(start: state.start, end: state.end, category: category);
  }

  static DateTime _startOfDay(DateTime dt) =>
      DateTime.utc(dt.year, dt.month, dt.day);

  static DateTime _endOfDay(DateTime dt) =>
      DateTime.utc(dt.year, dt.month, dt.day, 23, 59, 59, 999);
}

final analyticsFilterProvider =
    AutoDisposeNotifierProvider<AnalyticsFilterNotifier, AnalyticsFilter>(
        AnalyticsFilterNotifier.new);

/// PUBLIC_INTERFACE
/// Expose categories present in the current catalog.
final quizCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(_quizRepoProvider);
  final quizzes = await repo.getAllQuizzes();

  // Collect unique categories present
  final set = <String>{};
  for (final q in quizzes) {
    set.add(q.category);
  }

  // Normalize to ensure STEM/Humanities exist if present in data
  // Order requirement: ["All","STEM","Humanities", ...others alpha]
  final List<String> prioritized = [];
  if (set.contains('STEM')) prioritized.add('STEM');
  if (set.contains('Humanities')) prioritized.add('Humanities');

  // Remaining custom categories (if any)
  final others = set.difference({'STEM', 'Humanities'}).toList()..sort();

  // Do not include "All" here; UI will prepend it as a control label.
  final result = [...prioritized, ...others];
  return result;
});

/// PUBLIC_INTERFACE
/// Computes analytics from stored attempts and quiz catalog considering current filters.
/// Memoizes computed result for the current (start,end,category) tuple to avoid heavy recompute.
final quizAnalyticsProvider =
    FutureProvider.autoDispose<QuizAnalytics>((ref) async {
  final repo = ref.watch(_quizRepoProvider);
  final quizzes = await repo.getAllQuizzes();
  final store = await ref.watch(quizProgressStoreProvider.future);
  final filter = ref.watch(analyticsFilterProvider);

  // Filter quizzes by category, if any
  final filteredQuizzes = filter.category == null
      ? quizzes
      : quizzes.where((q) => (q.category) == filter.category).toList();

  // Aggregate over filtered attempts within date window
  int totalAttempts = 0;
  int completedCount = 0;
  double sumPct = 0.0;
  double bestPctGlobal = 0.0;
  int recentCount = 0; // attempts within 7/30 days respecting current window

  // For "recent" bar we consider last 7 or 30 days depending on window length
  final windowDays =
      filter.end.difference(filter.start).inDays + 1; // inclusive window
  final recentWindowDays = windowDays <= 14
      ? 7
      : windowDays <= 60
          ? 30
          : 30;
  final recentStart = filter.end.subtract(Duration(days: recentWindowDays - 1));

  final List<PerQuizStat> stats = [];

  for (final q in filteredQuizzes) {
    final attemptsAll = store.getAttempts(q.id);

    // select attempts within date range [start, end]
    final attempts = attemptsAll
        .where((a) => _within(a.timestamp, filter.start, filter.end))
        .toList();

    attempts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    totalAttempts += attempts.length;

    double avg = 0;
    double best = 0;
    double last = 0;

    if (attempts.isNotEmpty) {
      final pcts = attempts.map((a) => a.percent).toList();
      sumPct += pcts.fold(0.0, (a, b) => a + b);
      best = pcts.reduce((a, b) => a > b ? a : b);
      if (best > bestPctGlobal) bestPctGlobal = best;
      last = attempts.first.percent;
      avg = pcts.reduce((a, b) => a + b) / pcts.length;
      completedCount += 1;
    }

    // count recent attempts within min(end, recentWindowDays) respecting filter
    final recent = attempts.where((a) {
      final start = recentStart.isBefore(filter.start) ? filter.start : recentStart;
      return _within(a.timestamp, start, filter.end);
    }).length;
    recentCount += recent;

    stats.add(PerQuizStat(
      quiz: q,
      attempts: attempts.length,
      lastScorePct: last,
      bestScorePct: best,
      avgScorePct: avg,
      completedOnce: attempts.isNotEmpty,
    ));
  }

  final quizzesCount = filteredQuizzes.isEmpty ? 1 : filteredQuizzes.length;
  final kpis = QuizKpis(
    totalTaken: totalAttempts,
    avgScorePct: totalAttempts == 0 ? 0 : (sumPct / totalAttempts),
    bestScorePct: bestPctGlobal,
    completionRatePct: (completedCount / quizzesCount) * 100.0,
    recentAttemptsCount: recentCount,
  );

  return QuizAnalytics(kpis: kpis, perQuiz: stats);
});

bool _within(DateTime ts, DateTime start, DateTime end) {
  final t = ts.toUtc();
  return !t.isBefore(start) && !t.isAfter(end);
}

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
    AutoDisposeNotifierProvider<QuizAnalyticsRefresher, int>(
        QuizAnalyticsRefresher.new);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/quiz_analytics_provider.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/section_title.dart';

/// PUBLIC_INTERFACE
class AnalyticsScreen extends ConsumerWidget {
  /// Quiz results and analytics dashboard with KPIs and per-quiz breakdown.
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tie to refresher so updates propagate when attempts are recorded.
    ref.watch(quizAnalyticsRefresherProvider);
    final analytics = ref.watch(quizAnalyticsProvider);

    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return analytics.when(
      data: (data) {
        final k = data.kpis;
        final hasData = data.perQuiz.any((e) => e.attempts > 0);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SectionTitle('Progress Overview'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _kpiCard(context, 'Quizzes Taken', '${k.totalTaken}', Icons.check_circle,
                    cs.tertiary),
                _kpiCard(context, 'Avg Score', '${k.avgScorePct.toStringAsFixed(0)}%',
                    Icons.analytics_outlined, cs.primary),
                _kpiCard(context, 'Best Score', '${k.bestScorePct.toStringAsFixed(0)}%',
                    Icons.emoji_events_outlined, const Color(0xFFF59E0B)),
                _kpiCard(
                    context,
                    'Completion Rate',
                    '${k.completionRatePct.isNaN ? 0 : k.completionRatePct.toStringAsFixed(0)}%',
                    Icons.task_alt,
                    const Color(0xFF10B981)),
                _kpiCard(context, 'Last 7 days', '${k.last7DaysCount}', Icons.calendar_today,
                    Colors.purple),
              ],
            ),
            const SizedBox(height: 16),
            const SectionTitle('Per-Quiz Performance'),
            const SizedBox(height: 8),
            if (!hasData)
              _emptyState(context)
            else
              ...data.perQuiz.map((s) => _quizStatTile(context, s)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Failed to load analytics: $e', style: t.bodyMedium),
      ),
    );
  }

  Widget _kpiCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Container(
      width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2, // 2 per row on phones
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: cs.outline),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withAlpha(24),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.bodySmall),
                const SizedBox(height: 4),
                Text(value, style: t.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quizStatTile(BuildContext context, PerQuizStat s) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final avgPct = s.avgScorePct.isNaN ? 0.0 : s.avgScorePct;
    final bestPct = s.bestScorePct.isNaN ? 0.0 : s.bestScorePct;
    final lastPct = s.lastScorePct.isNaN ? 0.0 : s.lastScorePct;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Expanded(child: Text(s.quiz.title, style: t.bodyLarge)),
            _pill(context, '${s.attempts} attempts',
                color: cs.tertiary, bg: cs.tertiary.withAlpha(24)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _miniBar(context, label: 'Avg', valuePct: avgPct / 100.0, color: cs.primary),
            const SizedBox(width: 8),
            _miniBar(context, label: 'Best', valuePct: bestPct / 100.0, color: const Color(0xFFF59E0B)),
            const SizedBox(width: 8),
            _miniBar(context, label: 'Last', valuePct: lastPct / 100.0, color: const Color(0xFF10B981)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('Avg ${avgPct.toStringAsFixed(0)}%', style: t.bodySmall),
            const SizedBox(width: 12),
            Text('Best ${bestPct.toStringAsFixed(0)}%', style: t.bodySmall),
            const SizedBox(width: 12),
            if (s.completedOnce)
              _pill(context, 'Completed', color: const Color(0xFF10B981),
                  bg: const Color(0xFF10B981).withAlpha(24))
            else
              Text('Not completed yet', style: t.bodySmall),
          ],
        )
      ]),
    );
  }

  Widget _miniBar(BuildContext context,
      {required String label, required double valuePct, required Color color}) {
    final t = Theme.of(context).textTheme;
    final clamped = valuePct.clamp(0.0, 1.0);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: t.bodySmall),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFF3F4F6)),
                  FractionallySizedBox(
                    widthFactor: clamped,
                    child: Container(color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String text, {required Color color, required Color bg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
      ),
      child: Row(
        children: [
          Icon(Icons.insights_outlined, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('No attempts yet', style: t.bodyLarge),
              const SizedBox(height: 4),
              Text('Take a quiz to see your analytics here.', style: t.bodySmall),
            ]),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // go back to tabs
              },
              child: const Text('Browse Quizzes'),
            ),
          ),
        ],
      ),
    );
  }
}

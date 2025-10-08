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
    final filter = ref.watch(analyticsFilterProvider);
    final categoriesAsync = ref.watch(quizCategoriesProvider);

    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return analytics.when(
      data: (data) {
        final k = data.kpis;
        final hasData = data.perQuiz.any((e) => e.attempts > 0);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Filter Bar
            _filterBar(context, ref, categoriesAsync, filter),
            const SizedBox(height: 12),

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
                _kpiCard(context, 'Recent', '${k.recentAttemptsCount}', Icons.calendar_today,
                    Colors.purple),
              ],
            ),
            const SizedBox(height: 16),
            const SectionTitle('Per-Quiz Performance'),
            const SizedBox(height: 8),
            if (!hasData)
              _emptyStateFiltered(context, ref)
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

  Widget _filterBar(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<String>> categoriesAsync,
    AnalyticsFilter filter,
  ) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', style: t.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              // Category dropdown
              Expanded(
                child: categoriesAsync.when(
                  data: (cats) {
                    // Ensure desired order: ["All","STEM","Humanities", ...others]
                    final base = <String>[];
                    if (cats.contains('STEM')) base.add('STEM');
                    if (cats.contains('Humanities')) base.add('Humanities');
                    final others = cats.where((c) => c != 'STEM' && c != 'Humanities').toList();
                    final items = ['All', ...base, ...others];
                    final value = filter.category ?? 'All';
                    return DropdownButtonFormField<String>(
                      value: items.contains(value) ? value : 'All',
                      items: items
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ))
                          .toList(),
                      onChanged: (v) {
                        // After await rule: this is sync
                        final category = (v == null || v == 'All') ? null : v;
                        ref.read(analyticsFilterProvider.notifier).setCategory(category);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Category',
                      ),
                    );
                  },
                  loading: () => const LinearProgressIndicator(minHeight: 2),
                  error: (e, _) => Text('Categories error: $e', style: t.bodySmall),
                ),
              ),
              const SizedBox(width: 12),
              // Custom range button
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _rangeLabel(filter.start, filter.end),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDateRange: DateTimeRange(start: filter.start, end: filter.end),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  primary: const Color(0xFF2563EB),
                                  onPrimary: Colors.white,
                                ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      // After await: only update primitive state via provider
                      ref
                          .read(analyticsFilterProvider.notifier)
                          .setCustomRange(picked.start, picked.end);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _presetChip(context, ref, label: '7d', days: 7,
                  selected: _isSameRange(filter, days: 7)),
              _presetChip(context, ref, label: '14d', days: 14,
                  selected: _isSameRange(filter, days: 14)),
              _presetChip(context, ref, label: '30d', days: 30,
                  selected: _isSameRange(filter, days: 30)),
              _presetChip(context, ref, label: '90d', days: 90,
                  selected: _isSameRange(filter, days: 90)),
              _allChip(context, ref, selected: !_isSameRange(filter, days: 7) &&
                  !_isSameRange(filter, days: 14) &&
                  !_isSameRange(filter, days: 30) &&
                  !_isSameRange(filter, days: 90)),
            ],
          ),
        ],
      ),
    );
  }

  bool _isSameRange(AnalyticsFilter filter, {required int days}) {
    final now = DateTime.now().toUtc();
    final expectedStart =
        DateTime.utc(now.year, now.month, now.day).subtract(Duration(days: days - 1));
    final expectedEnd = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
    return filter.start == expectedStart && filter.end == expectedEnd;
  }

  Widget _presetChip(BuildContext context, WidgetRef ref,
      {required String label, required int days, required bool selected}) {
    final cs = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => ref.read(analyticsFilterProvider.notifier).setPresetDays(days),
      selectedColor: const Color(0xFFE6F0FF),
      shape: StadiumBorder(side: BorderSide(color: cs.outline)),
      backgroundColor: const Color(0xFFF7F7F8),
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
    );
  }

  Widget _allChip(BuildContext context, WidgetRef ref, {required bool selected}) {
    final cs = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: const Text('All'),
      selected: selected,
      onSelected: (_) {
        // set a wide range to include all (5 years back to future buffer)
        final now = DateTime.now().toUtc();
        final start = DateTime.utc(now.year - 5, now.month, now.day);
        final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
        ref.read(analyticsFilterProvider.notifier).setCustomRange(start, end);
      },
      selectedColor: const Color(0xFFE6F0FF),
      shape: StadiumBorder(side: BorderSide(color: cs.outline)),
      backgroundColor: const Color(0xFFF7F7F8),
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
    );
  }

  String _rangeLabel(DateTime start, DateTime end) {
    String two(int v) => v.toString().padLeft(2, '0');
    String fmt(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';
    return '${fmt(start)} to ${fmt(end)}';
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

  Widget _emptyStateFiltered(BuildContext context, WidgetRef ref) {
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
          Icon(Icons.filter_alt_off_outlined, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('No data for current filters', style: t.bodyLarge),
              const SizedBox(height: 4),
              Text('Try widening the date range or selecting All categories.', style: t.bodySmall),
            ]),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                final now = DateTime.now().toUtc();
                final start = DateTime.utc(now.year, now.month, now.day).subtract(const Duration(days: 29));
                final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
                ref.read(analyticsFilterProvider.notifier).setCategory(null);
                ref.read(analyticsFilterProvider.notifier).setCustomRange(start, end);
              },
              child: const Text('Reset Filters'),
            ),
          ),
        ],
      ),
    );
  }
}

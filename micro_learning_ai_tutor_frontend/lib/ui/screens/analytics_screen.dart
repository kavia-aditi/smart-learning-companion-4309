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
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            // Filter Bar
            _filterBar(context, ref, categoriesAsync, filter),
            const SizedBox(height: 16),

            const SectionTitle('Progress Overview'),
            const SizedBox(height: 12),

            // KPI grid with subtle animations
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: Wrap(
                key: ValueKey('${k.totalTaken}-${k.avgScorePct}-${k.bestScorePct}-${k.completionRatePct}-${k.recentAttemptsCount}'),
                spacing: 16,
                runSpacing: 16,
                children: [
                  KpiCard(
                    title: 'Quizzes Taken',
                    value: '${k.totalTaken}',
                    icon: Icons.check_circle,
                    accent: cs.tertiary,
                  ),
                  KpiCard(
                    title: 'Avg Score',
                    value: '${k.avgScorePct.toStringAsFixed(0)}%',
                    icon: Icons.analytics_outlined,
                    accent: cs.primary,
                  ),
                  const KpiCard(
                    title: 'Best Score',
                    value: null, // placeholder; value set later by build method
                    icon: Icons.emoji_events_outlined,
                    accent: Color(0xFFF59E0B),
                  ),
                  KpiCard(
                    title: 'Completion Rate',
                    value: '${k.completionRatePct.isNaN ? 0 : k.completionRatePct.toStringAsFixed(0)}%',
                    icon: Icons.task_alt,
                    accent: const Color(0xFF10B981),
                  ),
                  const KpiCard(
                    title: 'Recent',
                    value: null, // placeholder; value set later by build method
                    icon: Icons.calendar_today,
                    accent: Color(0xFF7C3AED), // purple-600
                  ),
                ].map((w) {
                  // inject the dynamic values for const placeholders
                  if (w.title == 'Best Score') {
                    return KpiCard(
                      title: w.title,
                      value: '${k.bestScorePct.toStringAsFixed(0)}%',
                      icon: w.icon,
                      accent: w.accent,
                    );
                  }
                  if (w.title == 'Recent') {
                    return KpiCard(
                      title: w.title,
                      value: '${k.recentAttemptsCount}',
                      icon: w.icon,
                      accent: w.accent,
                    );
                  }
                  return w;
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            const SectionTitle('Per-Quiz Performance'),
            const SizedBox(height: 12),

            if (!hasData)
              _emptyStateFiltered(context, ref)
            else
              // Animated list-like appearance for per-quiz tiles
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Column(
                  key: ValueKey('${filter.category}-${filter.start}-${filter.end}-${data.perQuiz.length}'),
                  children: data.perQuiz
                      .map((s) => _quizStatTile(context, s))
                      .toList(),
                ),
              ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x1A2563EB), // primary @ 10%
            Color(0xFFFFFEFE), // near white
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Filters', style: t.titleMedium),
              const SizedBox(width: 8),
              Builder(builder: (_) {
                final isPresetSelected = _isThisWeek(filter) ||
                    _isThisMonth(filter) ||
                    _isSameRange(filter, days: 7) ||
                    _isSameRange(filter, days: 14) ||
                    _isSameRange(filter, days: 30) ||
                    _isSameRange(filter, days: 90) ||
                    _isAll(filter);
                if (!isPresetSelected) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withAlpha(20),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFF2563EB)),
                    ),
                    child: const Text('Custom', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w700, fontSize: 12)),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
          const SizedBox(height: 12),
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
              const SizedBox(width: 16),
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
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              // New presets
              _weekChip(context, ref, selected: _isThisWeek(filter)),
              _monthChip(context, ref, selected: _isThisMonth(filter)),
              // Existing day presets
              _presetChip(context, ref, label: '7d', days: 7,
                  selected: _isSameRange(filter, days: 7)),
              _presetChip(context, ref, label: '14d', days: 14,
                  selected: _isSameRange(filter, days: 14)),
              _presetChip(context, ref, label: '30d', days: 30,
                  selected: _isSameRange(filter, days: 30)),
              _presetChip(context, ref, label: '90d', days: 90,
                  selected: _isSameRange(filter, days: 90)),
              // All
              _allChip(context, ref, selected: _isAll(filter)),
              // Reset chip
              _resetChip(context, ref),
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

  bool _isThisWeek(AnalyticsFilter filter) {
    final now = DateTime.now().toUtc();
    // Find Monday of this week (ISO: Monday=1)
    final weekday = now.weekday; // 1..7
    final monday = DateTime.utc(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
    final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
    return filter.start == monday && filter.end == end;
  }

  bool _isThisMonth(AnalyticsFilter filter) {
    final now = DateTime.now().toUtc();
    final first = DateTime.utc(now.year, now.month, 1);
    final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
    return filter.start == first && filter.end == end;
  }

  bool _isAll(AnalyticsFilter filter) {
    // Heuristic: All spans >= 5 years from today back
    final now = DateTime.now().toUtc();
    final fiveYearsAgo = DateTime.utc(now.year - 5, now.month, now.day);
    final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
    return filter.start == fiveYearsAgo && filter.end == end;
  }

  Widget _presetChip(BuildContext context, WidgetRef ref,
      {required String label, required int days, required bool selected}) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Preset $label',
      child: ChoiceChip(
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(label),
        ),
        selected: selected,
        onSelected: (_) => ref.read(analyticsFilterProvider.notifier).setPresetDays(days),
        selectedColor: const Color(0xFF2563EB), // Ocean primary
        shape: StadiumBorder(side: BorderSide(color: selected ? const Color(0xFF2563EB) : cs.outline)),
        backgroundColor: const Color(0xFFF7F7F8),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
        ),
        visualDensity: VisualDensity.standard,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  Widget _weekChip(BuildContext context, WidgetRef ref, {required bool selected}) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Preset This week',
      child: ChoiceChip(
        label: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text('This week'),
        ),
        selected: selected,
        onSelected: (_) {
          final now = DateTime.now().toUtc();
          final weekday = now.weekday; // Monday=1
          final start = DateTime.utc(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
          final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
          ref.read(analyticsFilterProvider.notifier).applyRange(start, end);
        },
        selectedColor: const Color(0xFF2563EB),
        shape: StadiumBorder(side: BorderSide(color: selected ? const Color(0xFF2563EB) : cs.outline)),
        backgroundColor: const Color(0xFFF7F7F8),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
        ),
        visualDensity: VisualDensity.standard,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  Widget _monthChip(BuildContext context, WidgetRef ref, {required bool selected}) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Preset This month',
      child: ChoiceChip(
        label: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text('This month'),
        ),
        selected: selected,
        onSelected: (_) {
          final now = DateTime.now().toUtc();
          final start = DateTime.utc(now.year, now.month, 1);
          final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
          ref.read(analyticsFilterProvider.notifier).applyRange(start, end);
        },
        selectedColor: const Color(0xFF2563EB),
        shape: StadiumBorder(side: BorderSide(color: selected ? const Color(0xFF2563EB) : cs.outline)),
        backgroundColor: const Color(0xFFF7F7F8),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium!.color,
        ),
        visualDensity: VisualDensity.standard,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  Widget _allChip(BuildContext context, WidgetRef ref, {required bool selected}) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: 'Preset All time',
      child: ChoiceChip(
        label: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text('All'),
        ),
        selected: selected,
        onSelected: (_) {
          // set a wide range to include all (5 years back)
          final now = DateTime.now().toUtc();
          final start = DateTime.utc(now.year - 5, now.month, now.day);
          final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
          ref.read(analyticsFilterProvider.notifier).applyRange(start, end);
        },
        selectedColor: const Color(0xFF2563EB),
        shape: StadiumBorder(side: BorderSide(color: selected ? const Color(0xFF2563EB) : cs.outline)),
        backgroundColor: const Color(0xFFF7F7F8),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
        ),
        visualDensity: VisualDensity.standard,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  Widget _resetChip(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: 'Reset filters',
      child: ActionChip(
        avatar: Icon(Icons.refresh, color: cs.primary, size: 18),
        label: const Text('Reset'),
        onPressed: () {
          final now = DateTime.now().toUtc();
          final start = DateTime.utc(now.year - 5, now.month, now.day);
          final end = DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
          ref.read(analyticsFilterProvider.notifier).setCategory(null);
          ref.read(analyticsFilterProvider.notifier).applyRange(start, end);
        },
        shape: StadiumBorder(side: BorderSide(color: cs.primary)),
        backgroundColor: cs.primary.withAlpha(20),
        labelStyle: TextStyle(
          color: cs.primary,
          fontWeight: FontWeight.w800,
        ),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  String _rangeLabel(DateTime start, DateTime end) {
    String two(int v) => v.toString().padLeft(2, '0');
    String fmt(DateTime d) => '${d.year}-${two(d.month)}-${two(d.day)}';
    return '${fmt(start)} to ${fmt(end)}';
  }



  Widget _quizStatTile(BuildContext context, PerQuizStat s) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final avgPct = s.avgScorePct.isNaN ? 0.0 : s.avgScorePct;
    final bestPct = s.bestScorePct.isNaN ? 0.0 : s.bestScorePct;
    final lastPct = s.lastScorePct.isNaN ? 0.0 : s.lastScorePct;

    // Category color accent
    final String cat = s.quiz.category ?? '';
    final Color accentBar = (cat.toLowerCase() == 'stem')
        ? cs.primary
        : (cat.toLowerCase() == 'humanities')
            ? const Color(0xFFF59E0B)
            : cs.tertiary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left accent bar
          Container(
            width: 4,
            height: 88,
            decoration: BoxDecoration(
              color: accentBar,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 14, 14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        s.quiz.title,
                        style: t.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _pill(context, '${s.attempts} attempts',
                        color: cs.tertiary, bg: cs.tertiary.withAlpha(24)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    SparkBar(label: 'Avg', valuePct: (avgPct / 100.0), color: cs.primary),
                    const SizedBox(width: 10),
                    const SparkBar(label: 'Best', valuePct: null, color: Color(0xFFF59E0B)),
                    const SizedBox(width: 10),
                    const SparkBar(label: 'Last', valuePct: null, color: Color(0xFF10B981)),
                  ].map((w) {
                    if (w is SparkBar && w.label == 'Best') {
                      return SparkBar(label: 'Best', valuePct: (bestPct / 100.0), color: w.color);
                    }
                    if (w is SparkBar && w.label == 'Last') {
                      return SparkBar(label: 'Last', valuePct: (lastPct / 100.0), color: w.color);
                    }
                    return w;
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Avg ${avgPct.toStringAsFixed(0)}%', style: t.bodySmall),
                    Text('Best ${bestPct.toStringAsFixed(0)}%', style: t.bodySmall),
                    if (s.completedOnce)
                      _pill(context, 'Completed',
                          color: const Color(0xFF10B981),
                          bg: const Color(0xFF10B981).withAlpha(24))
                    else
                      Text('Not completed yet', style: t.bodySmall),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }



  Widget _pill(BuildContext context, String text, {required Color color, required Color bg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cs.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.filter_alt_off_outlined, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('No data for current filters', style: t.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Try widening the date range or selecting All categories.',
                style: t.bodySmall,
              ),
            ]),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                final now = DateTime.now().toUtc();
                final start = DateTime.utc(now.year, now.month, now.day)
                    .subtract(const Duration(days: 29));
                final end =
                    DateTime.utc(now.year, now.month, now.day, 23, 59, 59, 999);
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

/// PUBLIC_INTERFACE
/// KPI Card reusable widget to standardize KPI tiles styling and layout.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String title;
  final String? value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    final double tileWidth =
        (MediaQuery.of(context).size.width - 20 * 2 - 16) / 2; // 2 per row on phones

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: tileWidth.clamp(150, 400),
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withAlpha(16),
            const Color(0xFFF9FAFB),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withAlpha(28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: t.bodySmall?.copyWith(
                      color: const Color(0xFF111827),
                    )),
                const SizedBox(height: 4),
                Text(
                  value ?? '',
                  style: t.displaySmall?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// PUBLIC_INTERFACE
/// Compact spark bar with rounded corners and animated width for value changes.
class SparkBar extends StatelessWidget {
  const SparkBar({
    super.key,
    required this.label,
    required this.valuePct,
    required this.color,
  });

  final String label;
  final double? valuePct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final double clamped = (valuePct ?? 0).clamp(0.0, 1.0);
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: clamped,
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        width: double.infinity,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

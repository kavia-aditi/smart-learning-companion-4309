import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/providers/recommendations_provider.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/gradient_header.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/recommendation_chip.dart';

/// PUBLIC_INTERFACE
class DashboardScreen extends ConsumerWidget {
  /// Dashboard showing progress summary and recommended lessons.
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final recs = ref.watch(recommendationsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        GradientHeader(
          child: Row(
            children: [
              Icon(Icons.insights, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Overall Progress', style: t.titleMedium),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.3,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF3F4F6),
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Streak: 2 days', style: t.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Recommendations', style: t.titleMedium),
        const SizedBox(height: 8),
        recs.when(
          data: (list) => Column(
            children: list
                .map((r) => Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outline),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: cs.tertiary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lesson ${r.lessonId}', style: t.bodyLarge),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    RecommendationChip(r.reason, icon: Icons.tag),
                                    RecommendationChip('Conf ${(r.confidence * 100).toStringAsFixed(0)}%'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ))
                .toList(),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Text('Failed to load recommendations: $e'),
        ),
      ],
    );
  }
}

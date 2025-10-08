import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AdaptiveRecommendations extends StatelessWidget {
  /// Placeholder list of AI-driven recommendations with tags.
  const AdaptiveRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final items = const [
      ('Atomic Structure Basics', ['Science', 'Beginner']),
      ('Renaissance Art Highlights', ['Art', 'History']),
      ('Algebra: Linear Equations', ['Math', 'Core']),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended for you', style: t.titleMedium),
        const SizedBox(height: 8),
        ...items.map((e) => _RecommendationTile(title: e.$1, tags: e.$2)),
      ],
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({required this.title, required this.tags});

  final String title;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline, color: cs.tertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: tags
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F8),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

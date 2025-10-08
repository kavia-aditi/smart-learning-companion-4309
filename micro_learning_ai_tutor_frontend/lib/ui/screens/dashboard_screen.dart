import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class DashboardScreen extends StatelessWidget {
  /** Base screen for Dashboard tab. Shows progress summary placeholder. */
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Your recent progress and insights.', style: t.bodyMedium),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
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
                        value: 0.62,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFF3F4F6),
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('Streak: 5 days', style: t.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

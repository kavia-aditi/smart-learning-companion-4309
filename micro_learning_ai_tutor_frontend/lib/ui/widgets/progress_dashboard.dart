import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class ProgressDashboard extends StatelessWidget {
  /// Shows overall progress summary and learning streak.
  const ProgressDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.insights_rounded, color: cs.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Progress', style: t.titleMedium),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: const LinearProgressIndicator(
                    value: 0.62,
                    minHeight: 8,
                    backgroundColor: Color(0xFFF3F4F6),
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 6),
                Text('Streak: 5 days', style: t.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

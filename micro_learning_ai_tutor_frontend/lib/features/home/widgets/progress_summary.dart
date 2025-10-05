import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';

/// PUBLIC_INTERFACE
class ProgressSummary extends StatelessWidget {
  const ProgressSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = context.select<AppState, int>((s) => s.lessonProgress.length);
    final avg = context.select<AppState, int>((s) {
      if (s.lessonProgress.isEmpty) return 0;
      final sum = s.lessonProgress.values.fold<int>(0, (a, b) => a + b);
      return (sum / s.lessonProgress.length).round();
    });

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.insights, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              total == 0 ? 'No progress yet. Start your first micro-lesson!' : 'Avg progress: $avg% across $total lessons',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Continue')),
        ],
      ),
    );
  }
}

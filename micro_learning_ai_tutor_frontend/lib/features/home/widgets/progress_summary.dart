import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/app_state.dart';
import '../../../app.dart' show kReduceMotion;

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

    final progressValue = (avg.clamp(0, 100)) / 100.0;

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
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progressValue),
                  duration: kReduceMotion ? Duration.zero : const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  builder: (context, value, _) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 6,
                      backgroundColor: const Color(0xFFE6EAF2),
                      color: theme.colorScheme.primary,
                    );
                  },
                ),
              ),
              const Icon(Icons.insights, size: 20),
            ],
          ),
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

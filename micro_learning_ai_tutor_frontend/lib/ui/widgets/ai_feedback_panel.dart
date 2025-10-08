import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AiFeedbackPanel extends StatelessWidget {
  /// Placeholder for AI tutor feedback with sample copy and CTA.
  const AiFeedbackPanel({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AI Tutor Feedback', style: t.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Great job! You’re improving on Science topics. Let’s reinforce key concepts with a short practice.',
            style: t.bodyMedium,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Get a tailored tip'),
          ),
        ],
      ),
    );
  }
}

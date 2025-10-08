import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/gradient_header.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/ocean_card.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/section_title.dart';

/// PUBLIC_INTERFACE
class DashboardScreen extends StatelessWidget {
  /// Base screen for Dashboard tab. Shows progress summary with gradient header and stats cards.
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;

    Widget statCard(IconData icon, String label, String value, Color color) {
      return OceanCard.elevated(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: color.withAlpha(26),
          child: Icon(icon, color: color),
        ),
        title: label,
        subtitle: value,
        onTap: () {},
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const SectionTitle('Overview'),
        const SizedBox(height: 8),

        // Gradient progress header
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
        const SizedBox(height: 16),

        const SectionTitle('Stats'),
        const SizedBox(height: 8),

        statCard(Icons.timer_outlined, 'Time learned this week', '42 min', cs.tertiary),
        const SizedBox(height: 12),
        statCard(Icons.check_circle_outline, 'Quizzes passed', '8 of 10', const Color(0xFF10B981)),
      ],
    );
  }
}

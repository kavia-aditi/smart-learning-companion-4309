import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/state/app_state.dart';

/// PUBLIC_INTERFACE
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lessons = context.select<AppState, int>((s) => s.lessonProgress.length);
    final quizzes = context.select<AppState, int>((s) => s.quizScores.length);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Your stats', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        _StatTile(label: 'Lessons in progress', value: '$lessons'),
        _StatTile(label: 'Quizzes completed', value: '$quizzes'),
        const SizedBox(height: 20),
        Text('Settings', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Daily reminders'),
          value: true,
          onChanged: (_) {},
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Theme'),
                subtitle: const Text('Ocean Professional'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('About'),
                trailing: const Icon(Icons.info_outline),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 3, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(value, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/gradient_header.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/section_title.dart';

/// PUBLIC_INTERFACE
class ProfileScreen extends StatelessWidget {
  /// Base screen for Profile tab. Shows profile header and settings list.
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const SectionTitle('Profile'),
        const SizedBox(height: 8),
        GradientHeader(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: cs.primary.withAlpha(26),
                child: Icon(Icons.person, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Johnson', style: t.titleMedium),
                    const SizedBox(height: 4),
                    Text('alex@example.com', style: t.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        const SectionTitle('Settings'),
        const SizedBox(height: 8),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: cs.outline),
          ),
          tileColor: cs.surface,
          leading: Icon(Icons.notifications_outlined, color: cs.tertiary),
          title: const Text('Notifications'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: cs.outline),
          ),
          tileColor: cs.surface,
          leading: Icon(Icons.lock_outline, color: cs.tertiary),
          title: const Text('Privacy & Security'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: cs.outline),
          ),
          tileColor: cs.surface,
          leading: Icon(Icons.help_outline, color: cs.tertiary),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 10),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: cs.outline),
          ),
          tileColor: cs.surface,
          leading: Icon(Icons.logout, color: cs.error),
          title: const Text('Logout'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/login');
          },
        ),
      ],
    );
  }
}

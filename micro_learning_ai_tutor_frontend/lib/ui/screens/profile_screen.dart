import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class ProfileScreen extends StatelessWidget {
  /** Base screen for Profile tab. Shows simple placeholder. */
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Profile settings placeholder', style: t.bodyMedium),
      ),
    );
  }
}

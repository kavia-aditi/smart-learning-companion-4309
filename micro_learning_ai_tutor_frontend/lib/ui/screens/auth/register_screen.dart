import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class RegisterScreen extends StatelessWidget {
  /// Registration placeholder; returns to Home after mock register.
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create account', style: t.displaySmall),
              const SizedBox(height: 8),
              Text('Join and start your learning journey', style: t.bodyMedium),
              const SizedBox(height: 24),
              const TextField(decoration: InputDecoration(hintText: 'Name')),
              const SizedBox(height: 12),
              const TextField(decoration: InputDecoration(hintText: 'Email')),
              const SizedBox(height: 12),
              const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Password')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                child: const Text('Back to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

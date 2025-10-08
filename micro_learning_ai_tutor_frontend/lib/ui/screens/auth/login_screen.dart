import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class LoginScreen extends StatelessWidget {
  /// Simple login placeholder that navigates to Home.
  const LoginScreen({super.key});

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
              Text('Welcome back', style: t.displaySmall),
              const SizedBox(height: 8),
              Text('Sign in to continue learning', style: t.bodyMedium),
              const SizedBox(height: 24),
              const TextField(decoration: InputDecoration(hintText: 'Email')),
              const SizedBox(height: 12),
              const TextField(obscureText: true, decoration: InputDecoration(hintText: 'Password')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed('/register'),
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

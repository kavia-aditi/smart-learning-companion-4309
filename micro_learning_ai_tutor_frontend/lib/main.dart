import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/theme/app_theme.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/auth/login_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/auth/register_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/home_screen.dart';

/// PUBLIC_INTERFACE
void main() {
  /// App entrypoint. Bootstraps the AI Tutor app with Ocean Professional theme.
  runApp(const AiTutorApp());
}

/// PUBLIC_INTERFACE
class AiTutorApp extends StatelessWidget {
  /// Root application widget configuring theming and entry navigation.
  const AiTutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micro-Learning AI Tutor',
      theme: AppTheme.light(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const AppShell(),
      },
    );
  }
}

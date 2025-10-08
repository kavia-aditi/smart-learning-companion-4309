import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:micro_learning_ai_tutor_frontend/theme/app_theme.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/auth/login_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/auth/register_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/dashboard_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/lesson_detail_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/home_screen.dart' as legacy_home;
import 'package:micro_learning_ai_tutor_frontend/ui/screens/quiz_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/profile_screen.dart';

/// PUBLIC_INTERFACE
void main() {
  /// App entrypoint. Bootstraps the AI Tutor app with ProviderScope for Riverpod.
  runApp(const ProviderScope(child: AiTutorApp()));
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
        '/home': (_) => const AppTabsShell(),
        '/lessons': (_) => const legacy_home.LessonsScreen(),
        '/lesson-detail': (_) => const LessonDetailScreen(),
        '/quiz': (_) => const QuizScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}

/// PUBLIC_INTERFACE
class AppTabsShell extends StatefulWidget {
  /// Bottom navigation shell hosting Lessons, Quizzes, Dashboard, Profile.
  const AppTabsShell({super.key});

  @override
  State<AppTabsShell> createState() => _AppTabsShellState();
}

class _AppTabsShellState extends State<AppTabsShell> {
  int _currentIndex = 0;

  static const _tabTitles = <String>[
    'Lessons',
    'Quizzes',
    'Dashboard',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = const <Widget>[
      legacy_home.LessonsScreen(),
      legacy_home.QuizzesScreen(),
      DashboardScreen(),
      ProfileScreen(),
    ];

    final body = SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IndexedStack(index: _currentIndex, children: pages),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_currentIndex]),
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Lessons',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quizzes',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

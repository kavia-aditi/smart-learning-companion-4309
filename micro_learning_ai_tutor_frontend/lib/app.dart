import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'core/state/app_state.dart';
import 'features/home/home_screen.dart';
import 'features/learn/learn_screen.dart';
import 'features/quizzes/quizzes_screen.dart';
import 'features/profile/profile_screen.dart';

/// PUBLIC_INTERFACE
class MicroLearningApp extends StatefulWidget {
  /// Root application widget configuring theme and navigation shell.
  const MicroLearningApp({super.key});

  @override
  State<MicroLearningApp> createState() => _MicroLearningAppState();
}

class _MicroLearningAppState extends State<MicroLearningApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LearnScreen(),
    QuizzesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Micro-Learning AI Tutor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme(),
        home: Scaffold(
          body: SafeArea(
            child: IndexedStack(index: _currentIndex, children: _pages),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (i) => setState(() => _currentIndex = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
                label: 'Learn',
              ),
              NavigationDestination(
                icon: Icon(Icons.quiz_outlined),
                selectedIcon: Icon(Icons.quiz),
                label: 'Quizzes',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/theme/app_theme.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/dashboard_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/home_screen.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/screens/profile_screen.dart';

/// PUBLIC_INTERFACE
class RiverpodAppShell extends StatefulWidget {
  /// Bottom navigation shell using Riverpod-powered screens.
  const RiverpodAppShell({super.key});

  @override
  State<RiverpodAppShell> createState() => _RiverpodAppShellState();
}

class _RiverpodAppShellState extends State<RiverpodAppShell> {
  int _currentIndex = 0;

  static const _tabTitles = <String>[
    'Lessons',
    'Dashboard',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final pages = const <Widget>[
      HomeScreen(),
      DashboardScreen(),
      ProfileScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_tabTitles[_currentIndex]),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IndexedStack(index: _currentIndex, children: pages),
          ),
        ),
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
      ),
    );
  }
}

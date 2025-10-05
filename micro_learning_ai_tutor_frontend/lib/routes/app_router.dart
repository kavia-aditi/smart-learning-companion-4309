import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AppRouter {
  /// Simple placeholder for future named routes.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not implemented')),
      ),
    );
  }
}

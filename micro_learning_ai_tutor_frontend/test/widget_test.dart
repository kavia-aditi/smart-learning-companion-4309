import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:micro_learning_ai_tutor_frontend/main.dart';

void main() {
  testWidgets('Home screen renders hero, subtitle, and cards', (WidgetTester tester) async {
    await tester.pumpWidget(const AiTutorApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Micro-Learning'), findsOneWidget);
    expect(find.text('Learn any topic in 5-minute lessons'), findsOneWidget);
    expect(find.text('Pick a topic'), findsOneWidget);
    expect(find.text('DAILY QUIZ'), findsOneWidget);
    expect(find.text('CHAT WITH EINSTEIN'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);
  });

  testWidgets('Bottom navigation has expected tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const AiTutorApp());
    await tester.pumpAndSettle();

    // Verify presence of bottom nav destinations by tapping icons/labels indirectly.
    expect(find.byIcon(Icons.home), findsNothing); // Not selected yet; outlined shown
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Quiz'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}

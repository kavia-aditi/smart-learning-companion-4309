import 'package:flutter_test/flutter_test.dart';
import 'package:micro_learning_ai_tutor_frontend/app.dart';

void main() {
  testWidgets('App boots and shows Home tab items', (WidgetTester tester) async {
    // Use the real root widget exported by lib/app.dart
    await tester.pumpWidget(const MicroLearningApp());
    await tester.pumpAndSettle();

    // Expect bottom navigation labels present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Quizzes'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Learn tab list renders after data load', (WidgetTester tester) async {
    await tester.pumpWidget(const MicroLearningApp());

    // Initially show a progress indicator in Learn tab when loading
    // Navigate to Learn tab by tapping its label
    await tester.pumpAndSettle();
    await tester.tap(find.text('Learn'));
    await tester.pump();

    // After async load settles, expect lesson tiles present from mock data
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(find.textContaining('Intro to AI'), findsWidgets);
  });
}

import 'package:flutter/material.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/lesson_card.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/quiz_card.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/progress_dashboard.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/ai_feedback_panel.dart';
import 'package:micro_learning_ai_tutor_frontend/ui/widgets/adaptive_recommendations.dart';

/// PUBLIC_INTERFACE
class AppShell extends StatefulWidget {
  /// Bottom navigation shell hosting Home, Lessons, Quizzes, Chat, Profile.
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const _HomeTab(),
      const _LessonsTab(),
      const _QuizzesTab(),
      const _ChatTab(),
      const _ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFDDEBFF),
              child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary, size: 18),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Lessons'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz), label: 'Quizzes'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Micro-Learning\nAI Tutor', style: t.displaySmall),
          const SizedBox(height: 8),
          Text('Learn any topic in 5-minute lessons', style: t.bodyMedium),
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 128,
              height: 128,
              decoration: const BoxDecoration(
                color: Color(0xFFDDEBFF),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.school_rounded, color: Theme.of(context).colorScheme.primary, size: 64),
            ),
          ),
          const SizedBox(height: 20),

          // Dashboard progress summary and streak
          const ProgressDashboard(),

          const SizedBox(height: 16),

          // AI tutor feedback placeholder
          const AiFeedbackPanel(),

          const SizedBox(height: 16),

          // Adaptive recommendations list
          const AdaptiveRecommendations(),

          const SizedBox(height: 16),

          Text('Continue Learning', style: t.titleMedium),
          const SizedBox(height: 8),
          // Example lesson cards
          Column(
            children: const [
              LessonCard(
                title: 'World War II Basics',
                duration: '5 min',
                badges: ['History', 'Beginner'],
                progress: 0.4,
              ),
              SizedBox(height: 12),
              LessonCard(
                title: 'Intro to Photosynthesis',
                duration: '6 min',
                badges: ['Science', 'Core'],
                progress: 0.7,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonsTab extends StatelessWidget {
  const _LessonsTab();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Lessons', style: t.titleMedium),
        const SizedBox(height: 12),
        const LessonCard(
          title: 'Impressionism Art Movement',
          duration: '7 min',
          badges: ['Art', 'Intermediate'],
          progress: 0.2,
        ),
        const SizedBox(height: 12),
        const LessonCard(
          title: 'Basics of Algebra',
          duration: '8 min',
          badges: ['Math', 'Beginner'],
          progress: 0.55,
        ),
      ],
    );
  }
}

class _QuizzesTab extends StatelessWidget {
  const _QuizzesTab();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Quizzes', style: t.titleMedium),
        const SizedBox(height: 12),
        const QuizCard(
          title: 'Daily Quiz',
          questions: 5,
          difficulty: 'Easy',
        ),
        const SizedBox(height: 12),
        const QuizCard(
          title: 'Science Mix',
          questions: 8,
          difficulty: 'Medium',
        ),
      ],
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('Chat coming soon — converse with your AI tutor.', style: t.bodyMedium),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

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

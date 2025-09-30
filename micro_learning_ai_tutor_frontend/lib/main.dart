import 'package:flutter/material.dart';
import 'services/api_client.dart';
import 'services/api_service.dart';

// PUBLIC_INTERFACE
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
    // Ocean Professional palette based on style_guide.md
    const Color primary = Color(0xFF2563EB); // --accent-pressed (primary from styleThemeData)
    const Color accent = Color(0xFF3B82F6); // --accent
    const Color secondary = Color(0xFFF59E0B); // amber
    const Color bgCanvas = Color(0xFFF9FAFB); // background
    const Color surface = Color(0xFFFFFFFF); // surface
    const Color textPrimary = Color(0xFF111827);

    const Color textMuted = Color(0xFF8A8F96);
    const Color border = Color(0xFFE5E7EB);
    const Color divider = Color(0xFFECECEC);
    const Color chipBg = Color(0xFFF7F7F8);
    const Color chipText = Color(0xFF1F2937);


    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.black,
        error: const Color(0xFFEF4444),
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
        tertiary: accent,
      ),
      scaffoldBackgroundColor: bgCanvas,
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );

    return MaterialApp(
      title: 'Micro-Learning AI Tutor',
      theme: base.copyWith(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          foregroundColor: textPrimary,
          centerTitle: false,
        ),
        dividerColor: divider,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: border),
            borderRadius: BorderRadius.circular(9999),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: border),
            borderRadius: BorderRadius.circular(9999),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: accent, width: 1.5),
            borderRadius: BorderRadius.circular(9999),
          ),
          hintStyle: const TextStyle(color: textMuted),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: chipBg,
          shape: StadiumBorder(side: BorderSide(color: border)),
          labelStyle: const TextStyle(
            color: chipText,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          selectedColor: const Color(0xFFE6F0FF),
          side: BorderSide(color: border),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0.8,
            shadowColor: Colors.black.withAlpha(20),
            minimumSize: const Size.fromHeight(48),
            backgroundColor: accent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ),
      home: const AppShell(),
    );
  }
}

/// Bottom navigation shell that hosts the primary tabs.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  // Keep pages in a list for tab navigation.
  final List<Widget> _pages = const <Widget>[
    HomeDashboardScreen(),
    LessonsPlaceholderScreen(),
    QuizPlaceholderScreen(),
    ChatPlaceholderScreen(),
    ProfilePlaceholderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int idx) {
          setState(() => _currentIndex = idx);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Learn'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined), selectedIcon: Icon(Icons.quiz), label: 'Quiz'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// PUBLIC_INTERFACE
class HomeDashboardScreen extends StatefulWidget {
  /// Home/dashboard UI inspired by the provided screenshot and notes.
  const HomeDashboardScreen({super.key});

  static const double _maxContentWidth = 560; // For tablet responsiveness.

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _projectsCount = 0;
  bool _initialized = false;

  // Fetch data without using context after await; only set primitive state.
  Future<void> _bootstrap() async {
    try {
      final client = ApiClient();
      // Try login with a demo account; if not exists, register then login.
      final ok = await client.login(email: 'demo@example.com', password: 'demo1234');
      if (!ok) {
        await client.register(email: 'demo@example.com', name: 'Demo User', password: 'demo1234');
        await client.login(email: 'demo@example.com', password: 'demo1234');
      }
      final projects = await client.listProjects();
      setState(() {
        _projectsCount = projects.length;
        _initialized = true;
      });
    } catch (_) {
      setState(() {
        _initialized = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Kick off bootstrap
    _bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 768;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: HomeDashboardScreen._maxContentWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with minimal chrome: can later add settings/profile button if needed.
                  Text(
                    'Micro-Learning\nAI Tutor',
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.2,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _initialized
                        ? 'Learn any topic in 5-minute lessons · Projects: $_projectsCount'
                        : 'Learn any topic in 5-minute lessons',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF666A70),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hero mascot avatar
                  Center(
                    child: Container(
                      width: isTablet ? 160 : 128,
                      height: isTablet ? 160 : 128,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDDEBFF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        color: cs.primary,
                        size: isTablet ? 72 : 64,
                        semanticLabel: 'Tutor mascot',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Topic Picker Card
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(text: 'Pick a topic'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _SelectableChip(label: 'History'),
                            _SelectableChip(label: 'Science', selected: true),
                            _SelectableChip(label: 'Art'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Daily Quiz Card
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(text: 'DAILY QUIZ'),
                        const SizedBox(height: 10),
                        Text(
                          '3 questions left',
                          style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF8A8F96)),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Start Quiz'),
                              SizedBox(width: 8),
                              Icon(Icons.chevron_right, size: 20, color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Chat Card
                  _CardContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionTitle(text: 'CHAT WITH EINSTEIN'),
                        const SizedBox(height: 12),
                        _InputPill(
                          hintText: 'Ask a question',
                          onSubmitted: (value) {
                            // No navigation or context operations here after await (none used).
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Reusable card container with border and rounded corners following the style guide.
class _CardContainer extends StatelessWidget {
  const _CardContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // Subtle shadow for modern depth
          BoxShadow(
            color: Colors.black.withAlpha(10),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

/// Section title text widget (uppercase allowed by design).
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

/// Selectable pill-shaped chip for topic selection.
class _SelectableChip extends StatefulWidget {
  const _SelectableChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  State<_SelectableChip> createState() => _SelectableChipState();
}

class _SelectableChipState extends State<_SelectableChip> {
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.tertiary;
    return ChoiceChip(
      label: Text(widget.label),
      selected: _selected,
      onSelected: (val) {
        setState(() => _selected = val);
      },
      labelStyle: TextStyle(
        color: _selected ? accent : const Color(0xFF1F2937),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      selectedColor: const Color(0xFFE6F0FF),
      backgroundColor: const Color(0xFFF7F7F8),
      shape: StadiumBorder(
        side: BorderSide(color: _selected ? accent : const Color(0xFFE5E7EB)),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
    );
  }
}

/// Input-like pill for chat placeholder.
class _InputPill extends StatelessWidget {
  const _InputPill({required this.hintText, this.onSubmitted});

  final String hintText;
  final void Function(String value)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    // This is a simple TextField styled as a pill input.
    return TextField(
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF8A8F96), size: 20),
      ),
    );
  }
}

// Placeholder screens for other tabs. Keep simple but themed.

class LessonsPlaceholderScreen extends StatefulWidget {
  const LessonsPlaceholderScreen({super.key});

  @override
  State<LessonsPlaceholderScreen> createState() => _LessonsPlaceholderScreenState();
}

class _LessonsPlaceholderScreenState extends State<LessonsPlaceholderScreen> {
  bool _loading = true;
  String _error = '';
  List<dynamic> _lessons = const [];

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    try {
      // Example usage of ApiService (Node.js backend):
      // Set base URL with:
      // flutter run --dart-define=NODE_API_BASE_URL=http://localhost:3000
      final svc = ApiService();
      final lessons = await svc.fetchLessons();
      setState(() {
        _lessons = lessons;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load lessons';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const _CenteredPlaceholder(title: 'Lessons', subtitle: 'Loading lessons...');
    }
    if (_error.isNotEmpty) {
      return _CenteredPlaceholder(title: 'Lessons', subtitle: _error);
    }
    if (_lessons.isEmpty) {
      return const _CenteredPlaceholder(title: 'Lessons', subtitle: 'No lessons available yet.');
    }

    final theme = Theme.of(context);
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _lessons.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = _lessons[index] as Map<String, dynamic>? ?? {};
          final title = (item['title'] ?? 'Untitled').toString();
          final summary = (item['summary'] ?? '').toString();
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  summary.isEmpty ? 'Tap to open lesson.' : summary,
                  style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF666A70)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QuizPlaceholderScreen extends StatelessWidget {
  const QuizPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CenteredPlaceholder(title: 'Quiz', subtitle: 'Attempt daily quizzes and track progress.');
  }
}

class ChatPlaceholderScreen extends StatelessWidget {
  const ChatPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CenteredPlaceholder(title: 'Chat', subtitle: 'Converse with the AI tutor in real-time.');
  }
}

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CenteredPlaceholder(title: 'Profile', subtitle: 'View and edit your learning profile.');
  }
}

class _CenteredPlaceholder extends StatelessWidget {
  const _CenteredPlaceholder({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: theme.colorScheme.tertiary),
              const SizedBox(height: 16),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF666A70)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

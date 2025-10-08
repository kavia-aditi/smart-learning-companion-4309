import 'package:micro_learning_ai_tutor_frontend/lib_fix.dart' show inlineFuture;
import 'package:micro_learning_ai_tutor_frontend/models/lesson.dart';

/// PUBLIC_INTERFACE
class MockLessonsRepository {
  /// Returns seeded mock lessons.
  Future<List<Lesson>> getLessons() => inlineFuture(_sampleLessons);

  /// Returns a lesson by id, or null if not found.
  Future<Lesson?> getLessonById(String id) =>
      inlineFuture(_sampleLessons.firstWhere((l) => l.id == id, orElse: () => _sampleLessons.first));

  // Seed data
  static final List<Lesson> _sampleLessons = <Lesson>[
    Lesson(
      id: 'lsn_war2',
      title: 'World War II Basics',
      description: 'Understand the key events and causes of WWII in under 5 minutes.',
      durationMinutes: 5,
      level: 'Beginner',
      tags: ['History', 'War', '20th Century'],
      content: [
        'World War II began in 1939 and ended in 1945.',
        'Major powers included the Allies and Axis.',
        'Key events: Invasion of Poland, Battle of Britain, D-Day, Hiroshima & Nagasaki.'
      ],
      thumbnailUrl: null,
    ),
    Lesson(
      id: 'lsn_photosyn',
      title: 'Intro to Photosynthesis',
      description: 'How plants convert light into energy.',
      durationMinutes: 6,
      level: 'Core',
      tags: ['Science', 'Biology'],
      content: [
        'Photosynthesis occurs in chloroplasts.',
        'Light-dependent reactions and the Calvin cycle.',
        'Outputs include glucose and oxygen.'
      ],
      thumbnailUrl: null,
    ),
    Lesson(
      id: 'lsn_algebra',
      title: 'Basics of Algebra',
      description: 'Variables, expressions, and simple equations.',
      durationMinutes: 8,
      level: 'Beginner',
      tags: ['Math', 'Core'],
      content: [
        'Algebra uses symbols to represent numbers.',
        'Solve for x by balancing operations on both sides.',
      ],
      thumbnailUrl: null,
    ),
  ];
}

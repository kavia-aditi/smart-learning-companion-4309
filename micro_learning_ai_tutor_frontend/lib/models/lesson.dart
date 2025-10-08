/// PUBLIC_INTERFACE
class Lesson {
  /// A micro-lesson entity with minimal content blocks.
  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.level,
    required this.tags,
    required this.content,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final String level; // e.g. Beginner/Intermediate/Advanced
  final List<String> tags;
  final List<String> content; // list of paragraph text blocks
  final String? thumbnailUrl;

  /// Convenience display for '5 min'
  String get prettyDuration => '$durationMinutes min';
}

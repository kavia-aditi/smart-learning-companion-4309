/// PUBLIC_INTERFACE
class Lesson {
  /// Represents a micro-lesson item.
  Lesson({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.summary,
    this.progress = 0,
    this.sections = const [],
  });

  final String id;
  final String title;
  final int durationMinutes;
  final String summary;
  final int progress; // 0..100
  final List<String> sections;

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      durationMinutes: int.tryParse(json['duration_minutes']?.toString() ?? '') ?? (json['duration'] ?? 5),
      summary: (json['summary'] ?? '').toString(),
      progress: int.tryParse(json['progress']?.toString() ?? '0') ?? 0,
      sections: (json['sections'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'duration_minutes': durationMinutes,
        'summary': summary,
        'progress': progress,
        'sections': sections,
      };

  Lesson copyWith({int? progress}) {
    return Lesson(
      id: id,
      title: title,
      durationMinutes: durationMinutes,
      summary: summary,
      progress: progress ?? this.progress,
      sections: sections,
    );
  }
}

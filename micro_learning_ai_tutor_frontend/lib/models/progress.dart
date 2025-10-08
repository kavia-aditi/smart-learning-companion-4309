/// PUBLIC_INTERFACE
class Progress {
  /// Tracks per-lesson progress for a user.
  Progress({
    this.userId,
    required this.lessonId,
    required this.completed,
    required this.currentStep,
    this.score,
    required this.lastUpdated,
  });

  final String? userId;
  final String lessonId;
  final bool completed;
  final int currentStep;
  final double? score;
  final DateTime lastUpdated;

  Progress copyWith({
    String? userId,
    String? lessonId,
    bool? completed,
    int? currentStep,
    double? score,
    DateTime? lastUpdated,
  }) {
    return Progress(
      userId: userId ?? this.userId,
      lessonId: lessonId ?? this.lessonId,
      completed: completed ?? this.completed,
      currentStep: currentStep ?? this.currentStep,
      score: score ?? this.score,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

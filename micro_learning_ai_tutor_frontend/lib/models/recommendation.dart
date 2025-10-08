/// PUBLIC_INTERFACE
class Recommendation {
  /// A recommended lesson reference with a rationale and confidence 0..1.
  Recommendation({
    required this.id,
    required this.lessonId,
    required this.reason,
    required this.confidence,
  });

  final String id;
  final String lessonId;
  final String reason;
  final double confidence;
}

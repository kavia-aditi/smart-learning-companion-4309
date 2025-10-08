/// PUBLIC_INTERFACE
class Quiz {
  /// Quiz question tied to a lesson.
  Quiz({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  bool isCorrect(int index) => index == correctIndex;
}

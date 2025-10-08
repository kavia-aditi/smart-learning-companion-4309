/// PUBLIC_INTERFACE
class QuizCatalog {
  /// Represents a full quiz with multiple questions and metadata.
  QuizCatalog({
    required this.id,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.questions,
    this.category = 'General',
  });

  /// Unique id for the quiz.
  final String id;

  /// Title for the quiz card.
  final String title;

  /// Short description shown in the card/list.
  final String description;

  /// Difficulty string (Easy, Medium, Hard).
  final String difficulty;

  /// The list of questions.
  final List<QuizQuestion> questions;

  /// Category for grouping and analytics filters.
  /// Allowed values in this app: "STEM" or "Humanities".
  /// Note: This remains a plain String for backward compatibility (no enum to avoid breaking changes).
  final String category;

  /// Convenience accessor for question count.
  int get questionCount => questions.length;
}

/// PUBLIC_INTERFACE
class QuizQuestion {
  /// A single multiple-choice question.
  QuizQuestion({
    required this.text,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  /// The question text.
  final String text;

  /// Options to pick from.
  final List<String> options;

  /// Index of the correct answer in [options].
  final int correctIndex;

  /// Optional explanation to show after answering or on review.
  final String? explanation;

  /// Returns true if [index] is the correct choice.
  bool isCorrect(int index) => index == correctIndex;
}

/// PUBLIC_INTERFACE
class Quiz {
  /// Represents a quiz with multiple questions.
  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  final String id;
  final String title;
  final String description;
  final List<QuizQuestion> questions;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// PUBLIC_INTERFACE
class QuizQuestion {
  QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: (json['id'] ?? '').toString(),
      prompt: (json['prompt'] ?? '').toString(),
      options: (json['options'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      correctIndex: int.tryParse(json['correct_index']?.toString() ?? '0') ?? 0,
      explanation: json['explanation']?.toString(),
    );
  }
}

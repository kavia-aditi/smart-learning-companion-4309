import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';

/// PUBLIC_INTERFACE
class MockQuizzesData {
  /// In-memory catalog of quizzes for the app.
  static final List<QuizCatalog> quizzes = <QuizCatalog>[
    QuizCatalog(
      id: 'quiz_history_ww2',
      title: 'World War II Basics',
      description: 'Key events and causes of WWII.',
      difficulty: 'Easy',
      questions: [
        QuizQuestion(
          text: 'In which year did World War II start?',
          options: ['1918', '1939', '1941', '1945'],
          correctIndex: 1,
          explanation: 'It began in 1939 with the invasion of Poland.',
        ),
        QuizQuestion(
          text: 'Which two major alliances fought in WWII?',
          options: ['East vs West', 'Allies vs Axis', 'North vs South', 'UN vs League'],
          correctIndex: 1,
          explanation: 'Allies vs Axis were the primary opposing sides.',
        ),
        QuizQuestion(
          text: 'Which event ended the war in the Pacific?',
          options: ['D-Day', 'Battle of Midway', 'Hiroshima & Nagasaki bombings', 'Pearl Harbor'],
          correctIndex: 2,
        ),
      ],
    ),
    QuizCatalog(
      id: 'quiz_science_photosynthesis',
      title: 'Photosynthesis',
      description: 'How plants convert light into energy.',
      difficulty: 'Easy',
      questions: [
        QuizQuestion(
          text: 'Where does photosynthesis primarily occur?',
          options: ['Mitochondria', 'Chloroplasts', 'Nucleus', 'Ribosomes'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Which gas do plants release during photosynthesis?',
          options: ['Carbon Dioxide', 'Oxygen', 'Nitrogen', 'Hydrogen'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'What pigment captures light energy?',
          options: ['Melanin', 'Hemoglobin', 'Chlorophyll', 'Keratin'],
          correctIndex: 2,
        ),
      ],
    ),
    QuizCatalog(
      id: 'quiz_math_algebra',
      title: 'Algebra Fundamentals',
      description: 'Variables, expressions, and equations.',
      difficulty: 'Medium',
      questions: [
        QuizQuestion(
          text: 'Solve: x + 5 = 12',
          options: ['5', '6', '7', '8'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Which is a variable?',
          options: ['7', 'x', '14', '3.5'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: '2x = 10, x = ?',
          options: ['2', '4', '5', '10'],
          correctIndex: 2,
        ),
      ],
    ),
    QuizCatalog(
      id: 'quiz_cs_python',
      title: 'Intro to Python',
      description: 'Basics of syntax and data types.',
      difficulty: 'Easy',
      questions: [
        QuizQuestion(
          text: 'How do you print text in Python?',
          options: ['echo("hi")', 'console.log("hi")', 'print("hi")', 'printf("hi")'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Which is a list literal?',
          options: ['{1,2,3}', '[1,2,3]', '(1,2,3)', '<1,2,3>'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'What is the boolean for true?',
          options: ['true', 'True', 'TRUE', '1'],
          correctIndex: 1,
        ),
      ],
    ),
    QuizCatalog(
      id: 'quiz_ai_ml',
      title: 'Machine Learning Basics',
      description: 'Core concepts and terminology.',
      difficulty: 'Medium',
      questions: [
        QuizQuestion(
          text: 'Supervised learning uses:',
          options: ['Unlabeled data', 'Labeled data', 'No data', 'Random labels'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Which is a common regression metric?',
          options: ['Accuracy', 'F1-score', 'RMSE', 'AUC'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Overfitting occurs when a model:',
          options: [
            'Generalizes well',
            'Is too simple',
            'Memorizes training data',
            'Uses too few features'
          ],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Train/validation/test split purpose is to:',
          options: [
            'Speed up training',
            'Tune and evaluate generalization',
            'Reduce data size',
            'Avoid labels'
          ],
          correctIndex: 1,
        ),
      ],
    ),
    QuizCatalog(
      id: 'quiz_softskills_comm',
      title: 'Communication Skills',
      description: 'Active listening and clarity.',
      difficulty: 'Easy',
      questions: [
        QuizQuestion(
          text: 'Active listening involves:',
          options: ['Interrupting', 'Eye contact and nodding', 'Multitasking', 'Finishing their sentences'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Clear communication is helped by:',
          options: ['Jargon', 'Ambiguity', 'Conciseness', 'Speed'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Which reduces misunderstandings?',
          options: ['Assumptions', 'Clarifying questions', 'Silence', 'Sarcasm'],
          correctIndex: 1,
        ),
      ],
    ),
    QuizCatalog(
      id: 'quiz_geography_world',
      title: 'World Geography',
      description: 'Capitals and landmarks.',
      difficulty: 'Hard',
      questions: [
        QuizQuestion(
          text: 'Capital of Australia?',
          options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'The Nile primarily flows through:',
          options: ['South America', 'Africa', 'Europe', 'Asia'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Mount Everest is on the border of:',
          options: ['India–China', 'Nepal–China', 'Nepal–India', 'Bhutan–China'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'The Sahara is a:',
          options: ['Forest', 'Desert', 'Mountain range', 'Plateau'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Tokyo is the capital of:',
          options: ['South Korea', 'China', 'Japan', 'Taiwan'],
          correctIndex: 2,
        ),
      ],
    ),
  ];
}

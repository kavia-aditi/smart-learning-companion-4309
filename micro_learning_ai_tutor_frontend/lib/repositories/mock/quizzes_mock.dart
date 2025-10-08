import 'package:micro_learning_ai_tutor_frontend/models/quiz.dart';

/// PUBLIC_INTERFACE
class MockQuizzesData {
  /// In-memory catalog of quizzes for the app.
  static final List<QuizCatalog> quizzes = <QuizCatalog>[
    // History
    QuizCatalog(
      id: 'quiz_history_ww2',
      title: 'World War II Basics',
      description: 'Key events and causes of WWII, distilled for quick recall.',
      difficulty: 'Easy',
      category: 'History',
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
        QuizQuestion(
          text: 'Which battle is often seen as a turning point in the Pacific?',
          options: ['Battle of the Bulge', 'Battle of Midway', 'El Alamein', 'Stalingrad'],
          correctIndex: 1,
        ),
      ],
    ),

    // Science - Biology
    QuizCatalog(
      id: 'quiz_science_photosynthesis',
      title: 'Photosynthesis Essentials',
      description: 'How plants convert light into energy with chlorophyll.',
      difficulty: 'Easy',
      category: 'Science',
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
        QuizQuestion(
          text: 'Primary source of energy driving photosynthesis?',
          options: ['Glucose', 'Sunlight', 'ATP', 'Heat'],
          correctIndex: 1,
        ),
      ],
    ),

    // Math - Algebra
    QuizCatalog(
      id: 'quiz_math_algebra',
      title: 'Algebra Fundamentals',
      description: 'Variables, expressions, and linear equations with confidence.',
      difficulty: 'Medium',
      category: 'Math',
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
        QuizQuestion(
          text: 'Simplify: 3(x + 2)',
          options: ['3x + 6', '3x + 2', 'x + 6', '6x'],
          correctIndex: 0,
        ),
      ],
    ),

    // CS - Python
    QuizCatalog(
      id: 'quiz_cs_python',
      title: 'Intro to Python',
      description: 'Syntax, print statements, and core data types — fast track.',
      difficulty: 'Easy',
      category: 'Tech',
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
        QuizQuestion(
          text: 'Which is a valid variable name?',
          options: ['2name', 'name_2', 'class', 'my-var'],
          correctIndex: 1,
        ),
      ],
    ),

    // AI/ML
    QuizCatalog(
      id: 'quiz_ai_ml',
      title: 'Machine Learning Basics',
      description: 'Core concepts: supervised vs unsupervised, metrics, overfitting.',
      difficulty: 'Medium',
      category: 'Tech',
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
        QuizQuestion(
          text: 'Unsupervised learning aims to:',
          options: ['Predict labels', 'Cluster or find structure', 'Generate labels', 'Reduce accuracy'],
          correctIndex: 1,
        ),
      ],
    ),

    // Soft skills
    QuizCatalog(
      id: 'quiz_softskills_comm',
      title: 'Communication Skills',
      description: 'Craft clarity, listen actively, and reduce misunderstandings.',
      difficulty: 'Easy',
      category: 'General',
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
        QuizQuestion(
          text: 'Empathy in communication is:',
          options: [
            'Ignoring others’ feelings',
            'Considering perspective and emotion',
            'Speaking louder',
            'Using complex words'
          ],
          correctIndex: 1,
        ),
      ],
    ),

    // Geography
    QuizCatalog(
      id: 'quiz_geography_world',
      title: 'World Geography',
      description: 'Capitals, landforms, and landmarks across the globe.',
      difficulty: 'Hard',
      category: 'Geography',
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

    // New: Chemistry
    QuizCatalog(
      id: 'quiz_science_chemistry',
      title: 'Chemistry Foundations',
      description: 'Atoms, bonds, and periodic trends with crisp clarity.',
      difficulty: 'Medium',
      category: 'Science',
      questions: [
        QuizQuestion(
          text: 'What is the atomic number of Carbon?',
          options: ['4', '6', '8', '12'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Ionic bonds are formed by:',
          options: ['Sharing electrons', 'Transferring electrons', 'Neutron exchange', 'Photon capture'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'NaCl is commonly known as:',
          options: ['Baking soda', 'Salt', 'Sugar', 'Lime'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Which subatomic particle has a negative charge?',
          options: ['Proton', 'Neutron', 'Electron', 'Positron'],
          correctIndex: 2,
        ),
      ],
    ),

    // New: Physics
    QuizCatalog(
      id: 'quiz_science_physics',
      title: 'Physics Fundamentals',
      description: 'Motion, forces, and energy—essentials in minutes.',
      difficulty: 'Medium',
      category: 'Science',
      questions: [
        QuizQuestion(
          text: 'Newton’s Second Law is:',
          options: ['F = ma', 'E = mc^2', 'V = IR', 'pV = nRT'],
          correctIndex: 0,
        ),
        QuizQuestion(
          text: 'Unit of force is:',
          options: ['Joule', 'Watt', 'Newton', 'Pascal'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Kinetic energy depends on:',
          options: ['Mass only', 'Velocity only', 'Mass and velocity', 'Pressure'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Friction is typically a force that:',
          options: ['Accelerates motion', 'Opposes motion', 'Creates energy', 'Increases mass'],
          correctIndex: 1,
        ),
      ],
    ),

    // New: World History (Renaissance)
    QuizCatalog(
      id: 'quiz_history_renaissance',
      title: 'The Renaissance',
      description: 'Artistic rebirth in Europe: figures, ideas, and impact.',
      difficulty: 'Easy',
      category: 'History',
      questions: [
        QuizQuestion(
          text: 'The Renaissance began in which region?',
          options: ['Scandinavia', 'Italy', 'Eastern Europe', 'North Africa'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Leonardo da Vinci painted:',
          options: ['Starry Night', 'Mona Lisa', 'The Scream', 'The Kiss'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Humanism emphasized:',
          options: ['Divine right', 'Human potential and achievements', 'Isolation', 'Total war'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Primary Renaissance city-state hub:',
          options: ['Florence', 'Dublin', 'Warsaw', 'Oslo'],
          correctIndex: 0,
        ),
      ],
    ),

    // New: Economics
    QuizCatalog(
      id: 'quiz_economics_basics',
      title: 'Economics Basics',
      description: 'Supply, demand, and incentives that shape decisions.',
      difficulty: 'Medium',
      category: 'General',
      questions: [
        QuizQuestion(
          text: 'Law of demand: As price increases, quantity demanded:',
          options: ['Increases', 'Decreases', 'Remains same', 'Becomes zero'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Opportunity cost is:',
          options: [
            'The cost of production',
            'Value of next best alternative forgone',
            'Accounting cost',
            'Sunk cost'
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Market equilibrium occurs when:',
          options: [
            'Supply equals demand',
            'Government sets price',
            'Only sellers benefit',
            'Only buyers benefit'
          ],
          correctIndex: 0,
        ),
        QuizQuestion(
          text: 'Elasticity measures:',
          options: [
            'Product quality',
            'Responsiveness to price changes',
            'Production capacity',
            'Market share'
          ],
          correctIndex: 1,
        ),
      ],
    ),

    // New: Digital Literacy / Cybersecurity
    QuizCatalog(
      id: 'quiz_digital_cybersec',
      title: 'Cybersecurity Essentials',
      description: 'Passwords, phishing, and safe browsing practices.',
      difficulty: 'Easy',
      category: 'Tech',
      questions: [
        QuizQuestion(
          text: 'Strong passwords include:',
          options: ['Only letters', 'Common words', 'Mix of cases, numbers, symbols', 'Birthdate'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Phishing is best described as:',
          options: [
            'Fishing online',
            'Malicious attempt to trick users',
            'Harmless spam',
            'Data encryption'
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Two-factor authentication (2FA) provides:',
          options: [
            'Slower login',
            'Extra security layer',
            'Free internet',
            'Password reset'
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Before clicking links, you should:',
          options: [
            'Ignore sender details',
            'Verify the source and URL',
            'Always click quickly',
            'Forward to friends'
          ],
          correctIndex: 1,
        ),
      ],
    ),

    // New: Data Science
    QuizCatalog(
      id: 'quiz_data_science',
      title: 'Data Science Overview',
      description: 'From data cleaning to modeling and evaluation.',
      difficulty: 'Medium',
      category: 'Tech',
      questions: [
        QuizQuestion(
          text: 'A common step before modeling is:',
          options: ['Deployment', 'Data cleaning', 'Version control', 'Load testing'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Which plot is best for distributions?',
          options: ['Bar chart', 'Histogram', 'Scatter plot', 'Line chart'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Cross-validation helps to:',
          options: [
            'Overfit the model',
            'Assess generalization performance',
            'Reduce dataset size',
            'Increase class imbalance'
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Feature engineering involves:',
          options: ['Collecting labels', 'Creating informative inputs', 'Tuning servers', 'Scaling teams'],
          correctIndex: 1,
        ),
      ],
    ),

    // New: English Grammar
    QuizCatalog(
      id: 'quiz_english_grammar',
      title: 'English Grammar',
      description: 'Parts of speech, tenses, and sentence clarity.',
      difficulty: 'Easy',
      category: 'Language',
      questions: [
        QuizQuestion(
          text: 'Identify the noun: "The cat slept."',
          options: ['The', 'cat', 'slept', '.'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Past tense of "go" is:',
          options: ['goed', 'goes', 'went', 'gone'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Choose the adjective:',
          options: ['Quickly', 'Run', 'Blue', 'Because'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'A complete sentence must have:',
          options: ['Only a subject', 'Subject and predicate', 'Only a verb', 'No verb'],
          correctIndex: 1,
        ),
      ],
    ),

    // New: Art History
    QuizCatalog(
      id: 'quiz_art_history',
      title: 'Art History Highlights',
      description: 'Movements, masterpieces, and cultural context.',
      difficulty: 'Medium',
      category: 'History',
      questions: [
        QuizQuestion(
          text: 'Impressionism is associated with:',
          options: ['Sharp realism', 'Light and color effects', 'Cubist angles', 'Surreal dreams'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Who painted "Starry Night"?',
          options: ['Van Gogh', 'Picasso', 'Da Vinci', 'Monet'],
          correctIndex: 0,
        ),
        QuizQuestion(
          text: 'Cubism pioneers include:',
          options: [
            'Picasso and Braque',
            'Van Gogh and Gauguin',
            'Monet and Manet',
            'Klimt and Schiele'
          ],
          correctIndex: 0,
        ),
        QuizQuestion(
          text: 'The Sistine Chapel ceiling was painted by:',
          options: ['Raphael', 'Michelangelo', 'Botticelli', 'Titian'],
          correctIndex: 1,
        ),
      ],
    ),

    // New: Environmental Science
    QuizCatalog(
      id: 'quiz_env_science',
      title: 'Environmental Science',
      description: 'Ecosystems, climate, and sustainable choices.',
      difficulty: 'Medium',
      category: 'Science',
      questions: [
        QuizQuestion(
          text: 'Greenhouse gases include:',
          options: ['O2 only', 'CO2 and CH4', 'N2 only', 'Ar only'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Biodiversity is important because it:',
          options: [
            'Reduces ecosystem resilience',
            'Improves ecosystem stability and services',
            'Has no effect',
            'Stops evolution'
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Renewable energy includes:',
          options: ['Coal', 'Solar', 'Oil', 'Natural gas'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Deforestation often leads to:',
          options: ['Increased habitat', 'Soil erosion', 'More rainfall', 'Cleaner air'],
          correctIndex: 1,
        ),
      ],
    ),

    // New: Finance Literacy
    QuizCatalog(
      id: 'quiz_finance_literacy',
      title: 'Personal Finance Basics',
      description: 'Budgeting, saving, and compound growth.',
      difficulty: 'Easy',
      category: 'General',
      questions: [
        QuizQuestion(
          text: 'A budget is used to:',
          options: ['Hide spending', 'Plan income and expenses', 'Increase taxes', 'Eliminate savings'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'Compound interest means:',
          options: [
            'Interest on initial principal only',
            'Interest on principal and accumulated interest',
            'No interest',
            'Penalty fee'
          ],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'An emergency fund typically covers:',
          options: ['1 day', '1–3 months', '3–6 months', '10 years'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'Diversification helps to:',
          options: ['Increase risk', 'Eliminate all risk', 'Spread risk across assets', 'Guarantee returns'],
          correctIndex: 2,
        ),
      ],
    ),

    // New: Web Dev Basics
    QuizCatalog(
      id: 'quiz_web_dev',
      title: 'Web Development Basics',
      description: 'HTML, CSS, and JavaScript fundamentals for rapid prototyping.',
      difficulty: 'Easy',
      category: 'Tech',
      questions: [
        QuizQuestion(
          text: 'HTML is primarily for:',
          options: ['Styling', 'Structure/markup', 'Programming logic', 'Databases'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'CSS controls:',
          options: ['Behavior', 'Data storage', 'Styles and layout', 'Server APIs'],
          correctIndex: 2,
        ),
        QuizQuestion(
          text: 'JavaScript runs in the browser to:',
          options: ['Compile CSS', 'Create interactivity', 'Render images only', 'Manage SQL'],
          correctIndex: 1,
        ),
        QuizQuestion(
          text: 'A responsive site adapts to:',
          options: ['Only desktop', 'Only mobile', 'Multiple screen sizes', 'Print only'],
          correctIndex: 2,
        ),
      ],
    ),
  ];

  /// PUBLIC_INTERFACE
  /// Helper to find a quiz by id (used in some widgets/tests).
  static QuizCatalog? find(String id) {
    return quizzes.where((q) => q.id == id).cast<QuizCatalog?>().firstOrNull;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}

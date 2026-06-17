class InterviewQuestion {
  final String question;
  final String category;
  final String difficulty;
  final String expectedAnswer;

  InterviewQuestion({
    required this.question,
    required this.category,
    required this.difficulty,
    required this.expectedAnswer,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      question: json['question'] ?? '',
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? '',
      expectedAnswer: json['expectedAnswer'] ?? '',
    );
  }
}

class InterviewFeedback {
  final int score;
  final String strengths;
  final String weaknesses;
  final String improvement;

  InterviewFeedback({
    required this.score,
    required this.strengths,
    required this.weaknesses,
    required this.improvement,
  });

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      score: json['score'] ?? 0,
      strengths: json['strengths'] ?? '',
      weaknesses: json['weaknesses'] ?? '',
      improvement: json['improvement'] ?? '',
    );
  }
}

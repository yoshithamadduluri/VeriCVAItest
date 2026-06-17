import 'dart:async';
import '../models/interview_models.dart';

class InterviewService {
  /// Returns a static list of predefined interview questions for offline use.
  Future<List<InterviewQuestion>> generateQuestions() async {
    // Simulate network delay for UI consistency
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      InterviewQuestion(
        question: 'What is Flutter?',
        category: 'Flutter Basics',
        difficulty: 'Beginner',
        expectedAnswer: 'Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase.',
      ),
      InterviewQuestion(
        question: 'Explain the difference between Stateless and Stateful widgets.',
        category: 'Widgets',
        difficulty: 'Beginner',
        expectedAnswer: 'A StatelessWidget has immutable state, meaning its properties cannot change once it is built. A StatefulWidget maintains state that can change over the widget\'s lifetime, allowing it to rebuild when the state changes.',
      ),
      InterviewQuestion(
        question: 'What is Dart and why does Flutter use it?',
        category: 'Dart Programming',
        difficulty: 'Intermediate',
        expectedAnswer: 'Dart is an object-oriented, class-based, garbage-collected language with C-style syntax. Flutter uses it because it supports both JIT (Just-In-Time) compilation for fast development cycles (hot reload) and AOT (Ahead-Of-Time) compilation for high-performance production builds.',
      ),
      InterviewQuestion(
        question: 'How do you manage state in a Flutter application?',
        category: 'State Management',
        difficulty: 'Intermediate',
        expectedAnswer: 'State can be managed using various approaches like setState for ephemeral state, or using state management solutions like Provider, Riverpod, BLoC, GetX, or Redux for app-wide state.',
      ),
      InterviewQuestion(
        question: 'How does Firebase integrate with a Flutter app?',
        category: 'Firebase Integration',
        difficulty: 'Intermediate',
        expectedAnswer: 'Firebase integrates with Flutter via official plugins (firebase_core, cloud_firestore, firebase_auth, etc.). You initialize Firebase using Firebase.initializeApp() and then use the respective plugin APIs to interact with Firebase services.',
      ),
      InterviewQuestion(
        question: 'Explain how to perform API calls in Flutter.',
        category: 'API Integration',
        difficulty: 'Advanced',
        expectedAnswer: 'API calls are typically performed using the http package or dio package. You make asynchronous HTTP requests (GET, POST, etc.), wait for the response, and then parse the JSON data into Dart objects using jsonDecode or generated serialization classes.',
      ),
    ];
  }

  /// Provides offline static evaluation of a user's answer.
  Future<InterviewFeedback> evaluateAnswer({
    required String question,
    required String userAnswer,
    required String expectedAnswer,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final answerLower = userAnswer.trim().toLowerCase();
    int score = 3;
    String strengths = 'Attempted to answer the question.';
    String weaknesses = 'The answer is too brief or lacks depth.';
    String improvement = 'Try to elaborate more on the key concepts discussed in the expected answer.';

    if (answerLower.isEmpty) {
      score = 0;
      strengths = 'None.';
      weaknesses = 'No answer provided.';
      improvement = 'Please provide an answer to be evaluated.';
    } else if (answerLower.length > 50) {
      score = 8;
      strengths = 'Provided a detailed response.';
      weaknesses = 'May contain minor inaccuracies compared to the expected answer.';
      improvement = 'Review the expected answer to refine your understanding.';
    } else if (answerLower.length > 20) {
      score = 6;
      strengths = 'Provided a basic explanation.';
      weaknesses = 'Lacks sufficient detail for a complete answer.';
      improvement = 'Expand on your points by comparing with the expected answer.';
    }

    return InterviewFeedback(
      score: score,
      strengths: strengths,
      weaknesses: weaknesses,
      improvement: improvement,
    );
  }
}

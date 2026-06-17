import 'package:flutter/material.dart';
import '../../services/interview_service.dart';
import '../../models/interview_models.dart';

class MockInterviewScreen extends StatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  final InterviewService _aiService = InterviewService();
  
  bool _isGenerating = false;
  bool _isEvaluating = false;
  
  List<InterviewQuestion>? _questions;
  int _currentQuestionIndex = 0;
  InterviewFeedback? _currentFeedback;
  
  final TextEditingController _answerController = TextEditingController();

  void _generateQuestions() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      final questions = await _aiService.generateQuestions();

      setState(() {
        _questions = questions;
        _currentQuestionIndex = 0;
        _currentFeedback = null;
        _answerController.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating questions: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _submitAnswer() async {
    if (_answerController.text.trim().isEmpty) return;

    setState(() {
      _isEvaluating = true;
    });

    try {
      final currentQuestion = _questions![_currentQuestionIndex];
      final feedback = await _aiService.evaluateAnswer(
        question: currentQuestion.question,
        userAnswer: _answerController.text,
        expectedAnswer: currentQuestion.expectedAnswer,
      );

      setState(() {
        _currentFeedback = feedback;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error evaluating answer: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEvaluating = false;
        });
      }
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions!.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _currentFeedback = null;
        _answerController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Interview Completed'),
          content: const Text('Great job! You have completed all the questions.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _questions = null;
                  _currentFeedback = null;
                  _answerController.clear();
                });
              },
              child: const Text('Finish'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Mock Interview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _questions == null ? _buildSetupView() : _buildInterviewView(),
      ),
    );
  }

  Widget _buildSetupView() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 24),
            const Text(
              'Flutter Mock Interview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Test your knowledge in Flutter, Dart, State Management, Widgets, Firebase, and API Integration.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateQuestions,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              icon: _isGenerating 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                : const Icon(Icons.play_arrow),
              label: Text(_isGenerating ? 'Loading Questions...' : 'Start Mock Interview'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterviewView() {
    final currentQuestion = _questions![_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions!.length,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} of ${_questions!.length}',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(currentQuestion.category),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  side: BorderSide.none,
                ),
                Chip(
                  label: Text(currentQuestion.difficulty),
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  side: BorderSide.none,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            currentQuestion.question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 16),
        
        if (_currentFeedback == null) ...[
          Expanded(
            child: TextField(
              controller: _answerController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                hintText: 'Type your answer here...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isEvaluating ? null : _submitAnswer,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isEvaluating 
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Submit Answer for Feedback'),
          ),
        ] else ...[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AI Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    color: Colors.green.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Score: ${_currentFeedback!.score}/10', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          const Text('Strengths:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_currentFeedback!.strengths),
                          const SizedBox(height: 8),
                          const Text('Weaknesses:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_currentFeedback!.weaknesses),
                          const SizedBox(height: 8),
                          const Text('Improvement:', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(_currentFeedback!.improvement),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Expected Answer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(currentQuestion.expectedAnswer),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _nextQuestion,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(_currentQuestionIndex == _questions!.length - 1 ? 'Finish Interview' : 'Next Question'),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';

class JobMatchScreen extends StatefulWidget {
  const JobMatchScreen({super.key});

  @override
  State<JobMatchScreen> createState() => _JobMatchScreenState();
}

class _JobMatchScreenState extends State<JobMatchScreen> {
  final TextEditingController _jobDescriptionController = TextEditingController();
  bool _isAnalyzing = false;
  Map<String, dynamic>? _matchResults;

  void _analyzeMatch() async {
    if (_jobDescriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please paste a job description first.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    // Simulating API interaction with Gemini for job match analysis
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isAnalyzing = false;
      _matchResults = {
        'matchPercentage': 78.0,
        'missingSkills': ['GraphQL', 'AWS S3'],
        'matchingSkills': ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
        'recommendation': 'Good match! Focus on learning GraphQL to improve your chances.',
      };
    });
  }

  @override
  void dispose() {
    _jobDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Match Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Paste the Job Description to see how well your resume matches the requirements.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _jobDescriptionController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Paste Job Description here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeMatch,
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.analytics),
              label: Text(_isAnalyzing ? 'Analyzing Match...' : 'Analyze Match'),
            ),
            if (_matchResults != null && !_isAnalyzing) ...[
              const SizedBox(height: 32),
              _buildResultsCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard(BuildContext context) {
    final match = _matchResults!['matchPercentage'] as double;
    final matchingSkills = _matchResults!['matchingSkills'] as List<String>;
    final missingSkills = _matchResults!['missingSkills'] as List<String>;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: match / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[300],
                      color: match > 75 ? Colors.green : Colors.orange,
                    ),
                  ),
                  Text(
                    '${match.toInt()}%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Overall Match Score',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 48),
            Text(
              'Matching Skills Found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: matchingSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Colors.green[100],
                  labelStyle: const TextStyle(color: Colors.green),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Missing Skills',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: missingSkills.map((skill) {
                return Chip(
                  label: Text(skill),
                  backgroundColor: Colors.red[100],
                  labelStyle: const TextStyle(color: Colors.red),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _matchResults!['recommendation'],
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

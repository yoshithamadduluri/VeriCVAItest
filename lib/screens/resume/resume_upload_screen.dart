import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ResumeUploadScreen extends StatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  String? _fileName;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResults;

  Future<void> _pickAndAnalyzeResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _isAnalyzing = true;
      });

      // TODO: Extract text from PDF using syncfusion_flutter_pdf
      // TODO: Send extracted text to AIService for analysis
      
      // Simulating API delay
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isAnalyzing = false;
        _analysisResults = {
          'atsScore': 85.0,
          'missingKeywords': ['Agile', 'Cloud Computing', 'CI/CD'],
          'suggestions': [
            'Add measurable results to your experience (e.g., "Increased sales by 20%").',
            'Include a brief professional summary.',
          ],
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload your resume to get an AI-powered ATS score and improvement suggestions.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _isAnalyzing ? null : _pickAndAnalyzeResume,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _fileName ?? 'Tap to Upload PDF/DOCX',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            if (_isAnalyzing) ...[
              const SizedBox(height: 48),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16),
              const Text(
                'Analyzing resume with AI...',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
            if (_analysisResults != null && !_isAnalyzing) ...[
              const SizedBox(height: 32),
              _buildResultsCard(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard(BuildContext context) {
    final score = _analysisResults!['atsScore'] as double;
    final missingKeywords = _analysisResults!['missingKeywords'] as List<String>;
    final suggestions = _analysisResults!['suggestions'] as List<String>;

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
                      value: score / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[300],
                      color: score > 80 ? Colors.green : (score > 60 ? Colors.orange : Colors.red),
                    ),
                  ),
                  Text(
                    '${score.toInt()}%',
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
                'ATS Compatibility Score',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 48),
            Text(
              'Missing Keywords',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: missingKeywords.map((keyword) {
                return Chip(
                  label: Text(keyword),
                  backgroundColor: Colors.red[100],
                  labelStyle: const TextStyle(color: Colors.red),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'AI Suggestions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...suggestions.map((suggestion) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(suggestion)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

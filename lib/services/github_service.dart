import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  final String _baseUrl = 'https://api.github.com';
  // Optional: Add PAT (Personal Access Token) for higher rate limits
  final String? _accessToken;

  GitHubService({String? accessToken}) : _accessToken = accessToken;

  Map<String, String> get _headers {
    final headers = {'Accept': 'application/vnd.github.v3+json'};
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      headers['Authorization'] = 'token $_accessToken';
    }
    return headers;
  }

  /// Fetches public repositories for a given user to analyze languages used.
  Future<Map<String, int>> analyzeUserLanguages(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/users/$username/repos?per_page=100'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> repos = json.decode(response.body);
        final Map<String, int> languageCounts = {};

        for (var repo in repos) {
          final language = repo['language'] as String?;
          if (language != null) {
            languageCounts[language] = (languageCounts[language] ?? 0) + 1;
          }
        }

        return languageCounts;
      } else {
        throw Exception('Failed to load repositories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('GitHub API error: $e');
    }
  }

  /// Calculates a confidence score for a claimed skill based on repository evidence.
  double calculateSkillConfidence(String skill, Map<String, int> languageCounts) {
    // Basic heuristic: if the skill is a language used in multiple repos, confidence is high.
    final count = languageCounts[skill];
    if (count == null) return 0.0;
    
    if (count > 10) return 95.0; // Very high confidence
    if (count > 5) return 80.0;  // High confidence
    if (count > 0) return 50.0;  // Moderate confidence
    
    return 0.0;
  }
}

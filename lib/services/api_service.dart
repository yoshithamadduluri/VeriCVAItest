import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Using gemini-1.5-flash as the default model
  static const String _modelName = 'gemini-1.5-flash';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  /// Fetch API key from .env file or environment variables
  String get _apiKey {
    final key = dotenv.env['GEMINI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('Missing API key. Please configure GEMINI_API_KEY in the .env file.');
    }
    return key;
  }

  /// Sends a prompt to the Gemini API and returns the generated text.
  Future<String> generateContent(String prompt) async {
    final apiKey = _apiKey;
    final url = Uri.parse('$_baseUrl/$_modelName:generateContent?key=$apiKey');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ],
      "generationConfig": {
        "responseMimeType": "application/json",
      }
    });

    if (kDebugMode) {
      print('=== API Request Debug Log ===');
      print('URL: \${url.scheme}://\${url.host}\${url.path}?key=HIDDEN_KEY');
      print('Headers: \$headers');
    }

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (kDebugMode) {
        print('=== API Response Debug Log ===');
        print('Status Code: \${response.statusCode}');
        print('Response Body: \${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        final candidates = responseData['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          if (content != null) {
            final parts = content['parts'] as List?;
            if (parts != null && parts.isNotEmpty) {
              return parts[0]['text'] ?? '';
            }
          }
        }
        throw Exception('Unexpected API response structure.');
      } else {
        // Handle specific API errors
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody['error']?['message'] ?? 'Unknown API Error';
        
        if (response.statusCode == 400) {
          if (errorMessage.contains('API key not valid')) {
            throw Exception('Invalid API key: The provided API key is not recognized by Google. Please check your GEMINI_API_KEY.');
          }
          throw Exception('Bad Request (400): \$errorMessage');
        } else if (response.statusCode == 404) {
          throw Exception('Model Not Found (404): The model \$_modelName is not available for this API key or region. Please ensure your project has the generative language API enabled.');
        } else if (response.statusCode == 401 || response.statusCode == 403) {
           throw Exception('Authorization Error (\${response.statusCode}): \$errorMessage');
        } else {
          throw Exception('API Error (\${response.statusCode}): \$errorMessage');
        }
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network Error: Failed to connect to the AI Provider. Please check your internet connection. Details: \$e');
    }
  }
}

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LlmLessonService {
  String get _apiKey => (dotenv.env['OPENAI_API_KEY'] ?? '').trim();
  String get _apiBase => (dotenv.env['OPENAI_BASE'] ?? 'https://api.openai.com/v1').trim();

  Future<String> translateText(String hebrewText) async {
    final system = 'You are a professional Hebrew-to-Russian translator. Keep output concise and accurate.';
    final prompt = 'Translate the following Hebrew text to Russian. Text: """$hebrewText"""';
    return _chat(system, prompt);
  }

  Future<String> generateLesson(String hebrewText) async {
    final system = 'Ты методист и преподаватель иврита. На основе входного текста сформируй компактный JSON-урок: {"words":[{"he":"","tr":"","ru":""}],"exercises":[{"type":"cards","items":[{"he":"","ru":""}]}],"quiz":[{"q":"","a":[""],"correct":0}]}.';
    final prompt = hebrewText;
    return _chat(system, prompt);
  }

  Future<String> _chat(String system, String user) async {
    if (_apiKey.isEmpty) {
      return 'Error: Missing OPENAI_API_KEY';
    }
    final uri = Uri.parse('$_apiBase/chat/completions');
    final body = {
      'model': 'gpt-4o-mini',
      'messages': [
        {'role': 'system', 'content': system},
        {'role': 'user', 'content': user},
      ],
      'temperature': 0.2,
      'max_tokens': 1200,
    };
    try {
      final resp = await http
          .post(
            uri,
            headers: {
              'Authorization': 'Bearer $_apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        return data['choices']?[0]?['message']?['content']?.toString() ?? '';
      }
      return 'Error: ${resp.statusCode}';
    } catch (e) {
      return 'Error: $e';
    }
  }
}



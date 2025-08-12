import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/translation_repository.dart';

class TranslationService {
  final TranslationRepository _repo = TranslationRepository();

  Future<String> translateHeToRu(String word) async {
    final cached = await _repo.get(word);
    if (cached != null) return cached;

    // Open-source MyMemory API (ограниченный, без ключа). Можно заменить на ключевой провайдер.
    final uri = Uri.parse('https://api.mymemory.translated.net/get?q=${Uri.encodeQueryComponent(word)}&langpair=he|ru');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final match = data['responseData']?['translatedText']?.toString();
      if (match != null && match.isNotEmpty) {
        await _repo.put(word, match);
        return match;
      }
    }
    // Фолбэк: вернуть исходное слово, если перевод недоступен
    return word;
  }

  Future<Map<String, String>> translateBatchHeToRu(List<String> words) async {
    final Map<String, String> result = {};
    for (final w in words) {
      result[w] = await translateHeToRu(w);
    }
    return result;
  }
}



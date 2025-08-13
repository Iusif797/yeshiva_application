import 'sense.dart';

class Lexeme {
  final int id;
  final String text;
  final String displayText;
  final int? gematriaStandard;
  final List<Sense> senses;
  final String? audioUrl;

  Lexeme({required this.id, required this.text, required this.displayText, required this.gematriaStandard, required this.senses, required this.audioUrl});

  factory Lexeme.fromJson(Map<String, dynamic> json) {
    final g = json['gematria'] is Map<String, dynamic> ? json['gematria'] as Map<String, dynamic> : {};
    final sensesJson = json['senses'] is List ? List<Map<String, dynamic>>.from(json['senses']) : <Map<String, dynamic>>[];
    return Lexeme(
      id: (json['id'] ?? 0) as int,
      text: json['text']?.toString() ?? '',
      displayText: json['display_text']?.toString() ?? '',
      gematriaStandard: g['standard'] is int ? g['standard'] as int : null,
      senses: sensesJson.map(Sense.fromJson).toList(),
      audioUrl: json['audio_url']?.toString(),
    );
  }
}

// Removed Hive adapter for Lexeme for now to unblock build.



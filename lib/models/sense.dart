class Sense {
  final String targetLang;
  final String gloss;
  final String explanation;

  const Sense({required this.targetLang, required this.gloss, required this.explanation});

  factory Sense.fromJson(Map<String, dynamic> json) => Sense(
        targetLang: json['target_lang']?.toString() ?? '',
        gloss: json['gloss']?.toString() ?? '',
        explanation: json['explanation']?.toString() ?? '',
      );
}



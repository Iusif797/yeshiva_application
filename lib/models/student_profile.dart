class StudentProfile {
  final int id;
  final String name;
  final String primaryLang;
  final String srsProvider;
  StudentProfile({required this.id, required this.name, required this.primaryLang, required this.srsProvider});
  factory StudentProfile.fromJson(Map<String, dynamic> json) => StudentProfile(
        id: (json['id'] ?? 0) as int,
        name: json['name']?.toString() ?? '',
        primaryLang: json['primary_lang']?.toString() ?? 'ru',
        srsProvider: json['srs_provider']?.toString() ?? 'duocards',
      );
}



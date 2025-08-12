import 'dart:convert';
import 'package:flutter/material.dart';

class LessonScreen extends StatelessWidget {
  final String lessonJson;
  const LessonScreen({super.key, required this.lessonJson});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {};
    try {
      data = jsonDecode(lessonJson) as Map<String, dynamic>;
    } catch (_) {}
    final words = (data['words'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final exercises = (data['exercises'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final quiz = (data['quiz'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Урок')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (words.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Слова', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ...words.map((w) => ListTile(
                          title: Text(w['he']?.toString() ?? '', textDirection: TextDirection.rtl),
                          subtitle: Text('${w['tr'] ?? ''} — ${w['ru'] ?? ''}'),
                        )),
                  ],
                ),
              ),
            ),
          if (exercises.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Упражнения', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ...exercises.map((e) => ListTile(
                          title: Text('Тип: ${e['type']}'),
                          subtitle: Text(e['items']?.toString() ?? ''),
                        )),
                  ],
                ),
              ),
            ),
          if (quiz.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Квиз', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ...quiz.map((q) => ListTile(
                          title: Text(q['q']?.toString() ?? ''),
                          subtitle: Text((q['a'] as List?)?.join(', ') ?? ''),
                        )),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}



import 'package:hive_flutter/hive_flutter.dart';
import '../models/lexeme.dart';

class CacheService {
  static const String lessonBox = 'lesson_cache_box';

  Future<Box> _open() => Hive.openBox(lessonBox);

  Future<void> saveLesson(int lessonId, Map<String, dynamic> lesson, List<Lexeme> lexemes) async {
    final box = await _open();
    await box.put('lesson_$lessonId', {'lesson': lesson, 'lexemes': lexemes});
  }

  Future<Map<String, dynamic>?> getLesson(int lessonId) async {
    final box = await _open();
    final v = box.get('lesson_$lessonId');
    if (v is Map<String, dynamic>) return v;
    return null;
  }
}

class AppSettingsCache {
  Future<void> saveSettings(Map<String, dynamic> data) async {
    final box = await Hive.openBox('app_settings');
    await box.put('settings', data);
    await box.close();
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final box = await Hive.openBox('app_settings');
    final res = box.get('settings') as Map<String, dynamic>?;
    await box.close();
    return res;
  }
}



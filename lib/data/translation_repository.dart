import 'package:hive_flutter/hive_flutter.dart';

class TranslationRepository {
  static const String boxName = 'translations_box';

  Future<Box<String>> _box() async {
    return await Hive.openBox<String>(boxName);
  }

  Future<String?> get(String word) async {
    final box = await _box();
    return box.get(word);
  }

  Future<void> put(String word, String translation) async {
    final box = await _box();
    await box.put(word, translation);
  }

  Future<Map<String, String>> getMany(Iterable<String> words) async {
    final box = await _box();
    final Map<String, String> result = {};
    for (final w in words) {
      final t = box.get(w);
      if (t != null) result[w] = t;
    }
    return result;
  }
}



import 'package:hive_flutter/hive_flutter.dart';

class WordRepository {
  static const String boxName = 'hebrew_words_box';

  Future<Box<String>> _box() async {
    return await Hive.openBox<String>(boxName);
  }

  Future<void> addWords(Iterable<String> words) async {
    final box = await _box();
    for (final w in words) {
      if (w.trim().isEmpty) continue;
      box.put(w, w);
    }
  }

  Future<List<String>> getAll() async {
    final box = await _box();
    final result = box.values.toSet().toList();
    result.sort((a, b) => a.compareTo(b));
    return result;
  }

  Future<void> clear() async {
    final box = await _box();
    await box.clear();
  }
}



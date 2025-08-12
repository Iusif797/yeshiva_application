import 'package:hive_flutter/hive_flutter.dart';

class StatsRepository {
  static const String boxName = 'stats_box';

  static const String keyLearned = 'learnedCount';
  static const String keyReviewed = 'reviewedCount';
  static const String keySessions = 'sessionCount';
  static const String keyStreakDays = 'streakDays';
  static const String keyLastActiveEpoch = 'lastActiveEpoch';

  Future<Box> _box() async => Hive.openBox(boxName);

  Future<Map<String, int>> read() async {
    final box = await _box();
    return {
      'learned': (box.get(keyLearned) ?? 0) as int,
      'reviewed': (box.get(keyReviewed) ?? 0) as int,
      'sessions': (box.get(keySessions) ?? 0) as int,
      'streak': (box.get(keyStreakDays) ?? 0) as int,
    };
  }

  Future<void> incrementSession() async {
    final box = await _box();
    box.put(keySessions, ((box.get(keySessions) ?? 0) as int) + 1);
    _updateStreak(box);
  }

  Future<void> addReviewed({bool learned = false}) async {
    final box = await _box();
    box.put(keyReviewed, ((box.get(keyReviewed) ?? 0) as int) + 1);
    if (learned) {
      box.put(keyLearned, ((box.get(keyLearned) ?? 0) as int) + 1);
    }
    _updateStreak(box);
  }

  void _updateStreak(Box box) {
    final nowDays = DateTime.now().toUtc().difference(DateTime(1970)).inDays;
    final lastEpoch = (box.get(keyLastActiveEpoch) ?? 0) as int;
    if (lastEpoch == nowDays) {
      // same day, do nothing
    } else if (lastEpoch == nowDays - 1) {
      box.put(keyStreakDays, ((box.get(keyStreakDays) ?? 0) as int) + 1);
    } else {
      box.put(keyStreakDays, 1);
    }
    box.put(keyLastActiveEpoch, nowDays);
  }
}



import 'package:flutter/material.dart';
import '../services/cache_service.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode mode = ThemeMode.system;
  final AppSettingsCache _cache = AppSettingsCache();
  Future<void> load() async {
    final s = await _cache.loadSettings();
    final v = s?['theme']?.toString();
    if (v == 'dark') mode = ThemeMode.dark; else if (v == 'light') mode = ThemeMode.light; else mode = ThemeMode.system;
    notifyListeners();
  }
  Future<void> setMode(ThemeMode m) async {
    mode = m;
    await _cache.saveSettings({'theme': m == ThemeMode.dark ? 'dark' : m == ThemeMode.light ? 'light' : 'system'});
    notifyListeners();
  }
  Future<void> toggleDark() async {
    if (mode == ThemeMode.dark) {
      await setMode(ThemeMode.light);
    } else {
      await setMode(ThemeMode.dark);
    }
  }
}



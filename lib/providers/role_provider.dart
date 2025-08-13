import 'package:flutter/foundation.dart';
import '../services/cache_service.dart';

enum AppRole { student, admin }

class RoleProvider extends ChangeNotifier {
  AppRole role = AppRole.student;
  final AppSettingsCache _cache = AppSettingsCache();
  Future<void> load() async {
    final s = await _cache.loadSettings();
    final v = s?['role']?.toString();
    role = v == 'admin' ? AppRole.admin : AppRole.student;
    notifyListeners();
  }
  Future<void> setRole(AppRole r) async {
    role = r;
    await _cache.saveSettings({'role': r == AppRole.admin ? 'admin' : 'student'});
    notifyListeners();
  }
}



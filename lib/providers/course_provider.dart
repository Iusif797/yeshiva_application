import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class CourseProvider extends ChangeNotifier {
  final ApiService api;
  CourseProvider(this.api);
  List<Map<String, dynamic>> courses = [];
  bool loading = false;
  String? error;
  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await api.getCourses();
      courses = data.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}



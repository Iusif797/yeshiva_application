import 'package:flutter/foundation.dart';
import '../models/lexeme.dart';
import '../services/api_service.dart';

class NewWordsProvider extends ChangeNotifier {
  final ApiService api;
  NewWordsProvider(this.api);
  List<Lexeme> items = [];
  final Set<int> selected = {};
  bool loading = false;
  String? error;
  int count = 0;
  double lessonProgress = 0.0;

  Future<void> load(int lessonId, int studentId) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final res = await api.getNewWords(lessonId, studentId);
      final list = res['words'] as List? ?? [];
      items = list.map((e) => Lexeme.fromJson(Map<String, dynamic>.from(e))).toList();
      count = res['count'] is int ? res['count'] as int : items.length;
      selected.clear();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void toggle(int id) {
    if (selected.contains(id)) selected.remove(id); else selected.add(id);
    notifyListeners();
  }

  void selectAll() {
    selected.addAll(items.map((e) => e.id));
    notifyListeners();
  }

  void clearSelection() {
    selected.clear();
    notifyListeners();
  }

  Future<void> markStudied(int lexemeId, {required int studentId}) async {
    final index = items.indexWhere((w) => w.id == lexemeId);
    if (index == -1) return;
    try {
      await api.exportToSrs(studentId, 'duocards', [lexemeId]);
    } catch (_) {}
    items.removeAt(index);
    selected.remove(lexemeId);
    count = items.length;
    _recalcProgress();
    notifyListeners();
  }

  void _recalcProgress() {
    final total = (items.length + 1).clamp(1, 100000);
    final learned = selected.length;
    lessonProgress = learned / total;
  }

  Future<void> setProgress(double v) async {
    lessonProgress = v.clamp(0.0, 1.0);
    notifyListeners();
  }
}



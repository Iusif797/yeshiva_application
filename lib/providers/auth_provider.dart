import 'package:flutter/foundation.dart';
import '../models/student_profile.dart';

class AuthProvider extends ChangeNotifier {
  StudentProfile? profile;
  bool get isAuthorized => profile != null;
  void setProfile(StudentProfile p) {
    profile = p;
    notifyListeners();
  }
  void clear() {
    profile = null;
    notifyListeners();
  }
}



import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ElderlyModeProvider extends ChangeNotifier {
  static const _key = 'elderly_mode_enabled';
  bool _isElderlyMode = false;

  ElderlyModeProvider() {
    _load();
  }

  bool get isElderlyMode => _isElderlyMode;

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isElderlyMode = prefs.getBool(_key) ?? false;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setElderlyMode(bool value) async {
    _isElderlyMode = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, value);
    } catch (_) {}
  }
}

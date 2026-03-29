import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String smsBoxName = 'sms_box';
  static const String userBoxName = 'user_box';
  static const String settingsBoxName = 'settings_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(smsBoxName);
    await Hive.openBox(userBoxName);
    await Hive.openBox(settingsBoxName);
  }

  // --- SMS Operations ---
  static List<Map<dynamic, dynamic>> getSmsHistory() {
    final box = Hive.box(smsBoxName);
    final List<dynamic> history = box.get('history', defaultValue: []);
    return history.map((e) => Map<dynamic, dynamic>.from(e)).toList();
  }

  static Future<void> saveSms(Map<String, dynamic> sms) async {
    final box = Hive.box(smsBoxName);
    final List<dynamic> history = box.get('history', defaultValue: []);
    history.insert(0, sms);
    await box.put('history', history);
  }

  static Future<void> deleteSms(int index) async {
    final box = Hive.box(smsBoxName);
    final List<dynamic> history = box.get('history', defaultValue: []);
    if (index >= 0 && index < history.length) {
      history.removeAt(index);
      await box.put('history', history);
    }
  }

  // --- User Operations ---
  static Future<void> setUserData(String key, dynamic value) async {
    final box = Hive.box(userBoxName);
    await box.put(key, value);
  }

  static dynamic getUserData(String key, {dynamic defaultValue}) {
    final box = Hive.box(userBoxName);
    return box.get(key, defaultValue: defaultValue);
  }

  // --- Settings (Theme) ---
  static Future<void> setTheme(String themeName) async {
    final box = Hive.box(settingsBoxName);
    await box.put('current_theme', themeName);
  }

  static String getTheme() {
    final box = Hive.box(settingsBoxName);
    return box.get('current_theme', defaultValue: 'amber');
  }
}

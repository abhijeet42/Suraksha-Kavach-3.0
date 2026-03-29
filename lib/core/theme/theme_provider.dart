import 'package:flutter/material.dart';
import '../../core/database/hive_service.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeType _currentTheme = AppThemeType.amber;

  AppThemeType get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() {
    final themeName = HiveService.getTheme();
    _currentTheme = AppThemeType.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => AppThemeType.amber,
    );
    notifyListeners();
  }

  void setTheme(AppThemeType type) {
    _currentTheme = type;
    HiveService.setTheme(type.name);
    notifyListeners();
  }

  ThemeData get themeData => AppTheme.getTheme(_currentTheme);
}

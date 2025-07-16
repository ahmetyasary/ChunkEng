import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';

  ThemeMode _currentThemeMode = ThemeMode.light; // Varsayılan açık tema

  ThemeMode get currentThemeMode => _currentThemeMode;

  ThemeProvider() {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      _currentThemeMode = _getThemeModeFromString(savedTheme);
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    _currentThemeMode = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _getStringFromThemeMode(themeMode));
    notifyListeners();
  }

  ThemeMode _getThemeModeFromString(String themeString) {
    switch (themeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  String _getStringFromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  String getThemeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Açık';
      case ThemeMode.dark:
        return 'Koyu';
      case ThemeMode.system:
        return 'Sistem';
    }
  }

  List<Map<String, dynamic>> getSupportedThemes() {
    return [
      {'mode': ThemeMode.light, 'name': 'Açık'},
      {'mode': ThemeMode.dark, 'name': 'Koyu'},
      {'mode': ThemeMode.system, 'name': 'Sistem'},
    ];
  }
}

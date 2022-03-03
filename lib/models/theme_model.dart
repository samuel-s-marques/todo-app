import 'package:flutter/material.dart';
import 'package:todoapp/utils/utils.dart';

class ThemeModel extends ChangeNotifier {
  late bool _isDark;
  late ThemePreferences _preferences;
  bool get isDark => _isDark;

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  ThemeModel() {
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }
}

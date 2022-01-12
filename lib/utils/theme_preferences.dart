import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const preferenceKey = "pref_key";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(preferenceKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(preferenceKey) ?? false;
  }
}
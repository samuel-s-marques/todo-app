import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const PREFERENCE_KEY = "pref_key";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PREFERENCE_KEY, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(PREFERENCE_KEY) ?? false;
  }
}
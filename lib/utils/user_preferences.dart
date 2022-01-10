import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  setTimeFormat(String timeFormat) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('timeFormat', timeFormat);
  }

  Future<String> getTimeFormat() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('timeFormat') ?? '24H';
  }
}
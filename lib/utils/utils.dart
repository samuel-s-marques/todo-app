import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/models/update_model.dart';

int generateId() {
  final _random = Random();

  return 0 + _random.nextInt(9999 - 0);
}

LocaleType languageFromCode(String code) {
  Map<LocaleType, String> _languageCode = {
    LocaleType.ar: 'ar',
    LocaleType.de: 'de',
    LocaleType.en: 'en',
    LocaleType.es: 'es',
    LocaleType.fr: 'fr',
    LocaleType.jp: 'ja',
    LocaleType.pt: 'pt',
    LocaleType.ru: 'ru',
    LocaleType.sv: 'sv',
  };

  for (var entry in _languageCode.entries) {
    if (entry.value == code) return entry.key;
  }

  return LocaleType.en;
}

class TranslatePreferences implements ITranslatePreferences {
  static const String _selectedLocaleKey = 'en';

  @override
  Future<Locale?> getPreferredLocale() async {
    final preferences = await SharedPreferences.getInstance();

    if (!preferences.containsKey(_selectedLocaleKey)) return null;

    var locale = preferences.getString(_selectedLocaleKey);
    return localeFromString(locale!);
  }

  @override
  Future savePreferredLocale(Locale locale) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_selectedLocaleKey, localeToString(locale));
  }
}

class ThemePreferences {
  static const preferenceKey = "themePrefs";

  setTheme(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(preferenceKey, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(preferenceKey) ?? false;
  }
}

Future<Map<String, dynamic>> checkUpdate() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  String currentVersion = version + "+" + buildNumber;

  Uri url = Uri.parse("https://samuel-s-marques.github.io/assets/json/todo_app/app.json");
  http.Response resp = await http.get(url);

  if (resp.statusCode == 200) {
    List<dynamic> updateObjects = jsonDecode(resp.body)['versions'] as List;
    List<Update> updates = updateObjects.map((update) => Update.fromJson(update)).toList();

    if (updates.last.version != currentVersion) {
      return {"success": "there's a new update"};
    }
  } else {
    return {"error": "internet connection error"};
  }

  return {"error": "without updates"};
}

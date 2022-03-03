import 'dart:math';
import 'dart:ui';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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

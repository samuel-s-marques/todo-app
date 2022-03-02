import 'dart:math';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

int generateId() {
  final _random = Random();

  return 0 + _random.nextInt(9999 - 0);
}

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

LocaleType languageFromCode(String code) {
  for (var entry in _languageCode.entries) {
    if (entry.value == code) return entry.key;
  }

  return LocaleType.en;
}

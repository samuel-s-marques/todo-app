import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/models/theme_model.dart';
import 'package:todoapp/pages/folders_page.dart';
import 'package:todoapp/pages/languages_page.dart';
import 'package:todoapp/pages/license_page.dart';
import 'package:todoapp/pages/privacy_policy_page.dart';
import 'package:todoapp/pages/settings_page.dart';
import 'package:todoapp/pages/tasks_page.dart';
import 'package:todoapp/pages/terms_and_conditions_page.dart';
import 'package:todoapp/utils/translate_preferences.dart';

void main() async {
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en', supportedLocales: ['en', 'pt', 'ja', 'es', 'ar', 'sv', 'fr'], preferences: TranslatePreferences());

  runApp(LocalizedApp(
    delegate,
    Provider<MyDb>(
      create: (context) => MyDb(),
      child: const MyApp(),
      dispose: (context, db) => db.close(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) {
            return MaterialApp(
              title: 'To-do app',
              localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, localizationDelegate],
              supportedLocales: localizationDelegate.supportedLocales,
              locale: localizationDelegate.currentLocale,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                brightness: Brightness.light,
                dialogBackgroundColor: const Color(0xFFFAFAFA),
                textTheme: TextTheme(
                  headlineLarge: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF575767),
                  ),
                  headlineMedium: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFB9B9BE),
                    decoration: TextDecoration.lineThrough,
                  ),
                  headlineSmall: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFB9B9BE),
                  ),
                  titleLarge: GoogleFonts.getFont(
                    "Inter",
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0E0E11),
                    fontSize: 20,
                  ),
                  titleMedium: GoogleFonts.getFont(
                    "Inter",
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF575757),
                    fontSize: 16,
                  ),
                ),
              ),
              // 0xFF202020
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                cardColor: const Color(0xFF141419),
                scaffoldBackgroundColor: const Color(0xFF141419),
                dialogBackgroundColor: const Color(0xFF303030),
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 16,
                    color: const Color(0xFFB9B9BE),
                  ),
                  fillColor: Colors.blue,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                textTheme: TextTheme(
                  headlineLarge: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFDADADA),
                  ),
                  headlineMedium: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF575767),
                    decoration: TextDecoration.lineThrough,
                  ),
                  headlineSmall: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF575767),
                  ),
                  bodyMedium: GoogleFonts.getFont(
                    "Inter",
                    fontSize: 16,
                    color: const Color(0xFFDADADA),
                  ),
                  titleLarge: GoogleFonts.getFont(
                    "Inter",
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFDADADA),
                    fontSize: 20,
                  ),
                  titleMedium: GoogleFonts.getFont(
                    "Inter",
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF575757),
                    fontSize: 16,
                  ),
                ),
              ),
              themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
              initialRoute: "/folders",
              routes: {
                "/folders": (context) => const FoldersPage(),
                "/tasks": (context) => const TasksPage(),
                "/settings": (context) => const SettingsPage(),
                "/languages": (context) => const LanguagesPage(),
                "/license": (context) => const ShowLicensePage(),
                "/privacy": (context) => const ShowPrivacyPolicyPage(),
                "/terms": (context) => const ShowTermsPage(),
              },
            );
          },
        ),
      ),
    );
  }
}

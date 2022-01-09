import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/pages/folders_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todoapp/pages/settings_page.dart';
import 'package:todoapp/pages/tasks_page.dart';

void main() async {
  runApp(Provider<MyDb>(
    create: (context) => MyDb(),
    child: const MyApp(),
    dispose: (context, db) => db.close(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pt', ''),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        dialogBackgroundColor: const Color(0xFFFAFAFA),
        textTheme: TextTheme(
          headline1: GoogleFonts.getFont(
            "Inter",
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF575767),
          ),
          headline2: GoogleFonts.getFont("Inter",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFB9B9BE),
              decoration: TextDecoration.lineThrough),
          subtitle1: GoogleFonts.getFont(
            "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFB9B9BE),
          ),
        ),
      ),
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
          headline1: GoogleFonts.getFont("Inter",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFDADADA)),
          headline2: GoogleFonts.getFont("Inter",
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF575767),
              decoration: TextDecoration.lineThrough),
          subtitle1: GoogleFonts.getFont(
            "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF575767),
          ),
          bodyText1: GoogleFonts.getFont("Inter",
              fontSize: 16,
              color: const Color(0xFFDADADA),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: "/folders",
      routes: {
        "/folders": (context) => const FoldersPage(),
        "/tasks": (context) => const TasksPage(),
        "/settings": (context) => const SettingsPage()
      },
    );
  }
}

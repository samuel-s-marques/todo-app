import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/models/theme_model.dart';
import 'package:todoapp/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool? autoUpdate;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sharedPreferences) {
      setState(() {
        autoUpdate = sharedPreferences.getBool('autoUpdate') ?? true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        bool lightMode = !themeNotifier.isDark;
        var localizedDelegate = LocalizedApp.of(context).delegate;

        return Scaffold(
          appBar: AppBar(),
          body: SettingsList(
            darkTheme: SettingsThemeData(settingsListBackground: Theme.of(context).scaffoldBackgroundColor),
            sections: [
              SettingsSection(
                title: Text(translate("settings_page.settings_section.title"), style: Theme.of(context).textTheme.headline3),
                tiles: [
                  SettingsTile.navigation(
                    leading: const Icon(Icons.language_outlined),
                    title: Text(
                      translate("settings_page.settings_section.language"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    value: Text(
                      translate("language.name.${localizedDelegate.currentLocale.languageCode}"),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14),
                    ),
                    onPressed: (context) {
                      Navigator.pushNamed(context, "/languages");
                    },
                  ),
                  SettingsTile.switchTile(
                    leading: const Icon(Icons.light_mode_outlined),
                    initialValue: lightMode,
                    onToggle: (bool value) {
                      themeNotifier.isDark = !themeNotifier.isDark;
                    },
                    title: Text(
                      translate("settings_page.settings_section.light_theme"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                  ),
                  SettingsTile.switchTile(
                    leading: const Icon(Icons.update_outlined),
                    title: Text(
                      translate("settings_page.support_section.update"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    initialValue: autoUpdate,
                    onToggle: (bool value) async {
                      final preferences = await SharedPreferences.getInstance();

                      setState(() {
                        preferences.setBool('autoUpdate', value);
                        autoUpdate = value;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: Text(
                  translate("settings_page.danger_section.title"),
                  style: Theme.of(context).textTheme.headline3,
                ),
                tiles: [
                  SettingsTile(
                    leading: const Icon(
                      Icons.dangerous_outlined,
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      translate("settings_page.danger_section.delete_all"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(translate("settings_page.danger_section.are_you_sure")),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                translate("settings_page.danger_section.cancel"),
                                style: GoogleFonts.getFont(
                                  "Inter",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<MyDb>(context, listen: false).deleteAllFolders();
                                Provider.of<MyDb>(context, listen: false).deleteAllTasks();

                                Navigator.pop(context);
                              },
                              child: Text(
                                translate("settings_page.danger_section.delete"),
                                style: GoogleFonts.getFont(
                                  "Inter",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: Text(translate("settings_page.support_section.title"), style: Theme.of(context).textTheme.headline3),
                tiles: [
                  SettingsTile(
                    leading: const Icon(Icons.device_unknown_outlined),
                    title: Text(
                      translate("settings_page.support_section.about"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    trailing: Text(
                      "v1.0.0",
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14),
                    ),
                    onPressed: (context) async {
                      Map<String, dynamic> response = await checkUpdate();

                      if (response.containsKey('success')) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Há uma nova atualização disponível!"),
                            content: Text("Gostaria de baixá-la?"),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("No, thanks")),
                              TextButton(
                                onPressed: () {
                                  launch('https://play.google.com/store/apps/details?id=com.samuel.todoapp');
                                  Navigator.pop(context);
                                },
                                child: Text("Sure"),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.share_outlined),
                    title: Text(
                      translate("settings_page.support_section.share.title"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    onPressed: (context) => Share.share(translate("settings_page.support_section.share.content")),
                  ),
                  SettingsTile(
                    leading: const Icon(
                      Icons.star_border_outlined,
                      color: Colors.deepOrange,
                    ),
                    title: Text(
                      translate("settings_page.support_section.rate"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    onPressed: (context) => LaunchReview.launch(
                      androidAppId: 'com.samuel.todoapp',
                    ),
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.source_outlined),
                    title: Text(
                      translate("settings_page.support_section.open_source"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    onPressed: (context) => Navigator.pushNamed(context, "/license"),
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.policy_outlined),
                    title: Text(
                      translate("settings_page.support_section.privacy"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    onPressed: (context) => Navigator.pushNamed(context, "/privacy"),
                  ),
                  SettingsTile(
                    leading: const Icon(Icons.person_outlined),
                    title: Text(
                      translate("settings_page.support_section.terms"),
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    onPressed: (context) => Navigator.pushNamed(context, "/terms"),
                  ),
                ],
              ),
              SettingsSection(
                title: Text(translate("settings_page.apps_section.title"), style: Theme.of(context).textTheme.headline3),
                tiles: [
                  SettingsTile(
                    title: Text(
                      "weather-app",
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),
                    ),
                    description: Text(
                      translate("settings_page.apps_section.weather_app.description"),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14),
                    ),
                    onPressed: (context) async => await launch("https://github.com/samuel-s-marques/weather-app#readme"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

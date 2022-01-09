import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:todoapp/database/database.dart';
import 'package:todoapp/models/theme_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        bool lightMode = !themeNotifier.isDark;

        print(AppLocalizations.of(context)!.localeName);

        return Scaffold(
          appBar: AppBar(),
          body: SettingsList(
            darkTheme: SettingsThemeData(settingsListBackground: Theme.of(context).scaffoldBackgroundColor),
            sections: [
              SettingsSection(
                title: Text('Configurações', style: Theme.of(context).textTheme.headline3),
                tiles: [
                  SettingsTile.navigation(
                    leading: const Icon(Icons.language_outlined),
                    title: Text("Linguagem", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),),
                    value: Text("Inglês", style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14),),
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.access_time_outlined),
                    title: Text("Padrão de hora", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),),
                    value: Text("24H", style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 14),),
                  ),
                  SettingsTile.switchTile(
                    leading: const Icon(Icons.light_mode_outlined),
                    initialValue: lightMode,
                    onToggle: (bool value) {
                      themeNotifier.isDark = !themeNotifier.isDark;
                    },
                    title: Text("Tema claro", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),),
                  ),
                ],
              ),
              SettingsSection(
                title: Text(
                  "Misc.",
                  style: Theme.of(context).textTheme.headline3,
                ),
                tiles: [
                  SettingsTile.navigation(
                    leading: const Icon(Icons.info_outline),
                    title: Text("Sobre", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),),
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.article_outlined),
                    title: Text("Termos de uso", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),),
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.copyright_outlined),
                    title: Text("Licença", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),),
                  ),
                ],
              ),
              SettingsSection(
                title: Text("Perigo", style: Theme.of(context).textTheme.headline3,),
                tiles: [
                  SettingsTile(
                    leading: const Icon(Icons.dangerous_outlined, color: Colors.redAccent,),
                    title: Text("Apagar todos os dados", style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 16),),
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Tem certeza que quer deletar todos os dados?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancelar",
                                style: GoogleFonts.getFont(
                                  "Inter",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<MyDb>(context, listen: false)
                                    .deleteAllFolders();
                                Provider.of<MyDb>(context, listen: false)
                                    .deleteAllTasks();

                                Navigator.pop(context);
                              },
                              child: Text(
                                "Apagar",
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
            ],
          ),
        );
      },
    );
  }
}

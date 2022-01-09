import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:todoapp/database/database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    bool lightMode = false;
    bool automaticDarkMode = true;

    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Configurações'),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.language_outlined),
                title: const Text("Linguagem"),
                value: const Text("Inglês"),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.access_time_outlined),
                title: const Text("Padrão de hora"),
                value: const Text("24H"),
              ),
              SettingsTile.switchTile(
                leading: const Icon(Icons.light_mode_outlined),
                initialValue: lightMode,
                onToggle: (bool value) {
                  lightMode = value;
                },
                title: const Text("Tema claro"),
              ),
              SettingsTile.switchTile(
                leading: const Icon(Icons.dark_mode_outlined),
                initialValue: automaticDarkMode,
                onToggle: (bool value) {
                  automaticDarkMode = value;
                },
                title: const Text("Tema escuro automático"),
              ),
            ],
          ),
          SettingsSection(
            title: const Text("Misc."),
            tiles: [
              SettingsTile.navigation(
                leading: const Icon(Icons.info_outline),
                title: const Text("Sobre"),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.article_outlined),
                title: const Text("Termos de uso"),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.copyright_outlined),
                title: const Text("Licença"),
              ),
            ],
          ),
          SettingsSection(
            title: const Text("Perigo"),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.dangerous_outlined),
                title: const Text("Apagar todos os dados"),
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
                            Provider.of<MyDb>(context, listen: false).deleteAllFolders();
                            Provider.of<MyDb>(context, listen: false).deleteAllTasks();

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
  }
}

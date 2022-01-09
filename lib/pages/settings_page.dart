import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Configurações'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.language_outlined),
                title: Text("Linguagem"),
                value: Text("Inglês"),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.access_time_outlined),
                title: Text("Padrão de hora"),
                value: Text("24H"),
              ),
              SettingsTile.switchTile(
                leading: Icon(Icons.light_mode_outlined),
                initialValue: true,
                onToggle: (bool value) {},
                title: Text("Tema claro"),
              ),
              SettingsTile.switchTile(
                leading: Icon(Icons.dark_mode_outlined),
                initialValue: true,
                onToggle: (bool value) {},
                title: Text("Tema escuro automático"),
              ),
            ],
          ),
          SettingsSection(
            title: Text("Misc."),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.info_outline),
                title: Text("Sobre"),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.article_outlined),
                title: Text("Termos de uso"),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.copyright_outlined),
                title: Text("Licença"),
              ),
            ],
          ),
          SettingsSection(
            title: Text("Perigo"),
            tiles: [
              SettingsTile(
                leading: Icon(Icons.dangerous_outlined),
                title: Text("Apagar todos os dados"),
                onPressed: (context) {
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

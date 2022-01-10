import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todoapp/utils/translate_preferences.dart';

class LanguagesPage extends StatefulWidget {
  const LanguagesPage({Key? key}) : super(key: key);

  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  @override
  Widget build(BuildContext context) {
    var localizedDelegate = LocalizedApp.of(context).delegate;

    return Scaffold(
      appBar: AppBar(
        title: Text(translate("language.selection.title"),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 16),
            child: Text(translate("language.selection.message"), style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 20),),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: localizedDelegate.supportedLocales.length,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile(
                title: Text(translate("language.name.${localizedDelegate.supportedLocales[index].languageCode}"), style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: 16),),
                value: localizedDelegate.supportedLocales[index],
                groupValue: localizedDelegate.currentLocale,
                onChanged: (value) {
                  changeLocale(context, localizedDelegate.supportedLocales[index].hashCode.toString());
                  TranslatePreferences().savePreferredLocale(Locale(localizedDelegate.supportedLocales[index].languageCode));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(translate("language.snackbar.message")))
                  );
                },
              );
            },
          ),
        ],
      )
    );
  }
}

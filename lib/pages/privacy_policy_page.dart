import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ShowPrivacyPolicyPage extends StatelessWidget {
  const ShowPrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> getFileLines() async {
      return await rootBundle.loadString("privacy_policy.md");
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder(
          future: getFileLines(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return Markdown(
              data: snapshot.data ?? translate("settings_page.support_section.loading"),
            );
          },
        ),
      ),
    );
  }
}

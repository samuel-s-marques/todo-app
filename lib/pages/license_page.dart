import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ShowLicensePage extends StatelessWidget {
  const ShowLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String> getFileLines() async {
      return await rootBundle.loadString("LICENSE");
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FutureBuilder(
            future: getFileLines(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return Text(
                snapshot.data ?? translate("settings_page.support_section.loading"),
                textAlign: TextAlign.justify,
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowLicensePage extends StatelessWidget {
  const ShowLicensePage({Key? key}) : super(key: key);

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
              return Text(snapshot.data ?? "Loading...", textAlign: TextAlign.justify,);
            },
          ),
        ),
      ),
    );
  }
}

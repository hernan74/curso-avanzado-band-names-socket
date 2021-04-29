import 'package:flutter/material.dart';

import 'package:band_names_app/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BandNamesApp',
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
      },
    );
  }
}

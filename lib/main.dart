import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:band_names_app/pages/home_page.dart';
import 'package:band_names_app/pages/status_page.dart';
import 'package:band_names_app/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(SocketService());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BandNamesApp',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: 'status', page: () => StatusPage()),
      ],
    );
  }
}

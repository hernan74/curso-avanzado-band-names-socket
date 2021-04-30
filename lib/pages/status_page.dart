import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:band_names_app/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Get.find<SocketService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('titulo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Obx(() => Text('${socketService.serverStatus.value}'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit(
              'mensaje', {'nombre': 'Hernan', 'mensaje': 'Hola desde flutter'});
        },
      ),
    );
  }
}

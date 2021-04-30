import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:band_names_app/services/socket_service.dart';
import 'package:band_names_app/models/band.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Get.find<SocketService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HomePage',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Obx(() {
              final bool estado =
                  (socketService.serverStatus.value == ServerStatus.Online);
              return Icon(
                estado ? Icons.check_circle : Icons.offline_bolt,
                color: estado ? Colors.blue : Colors.red,
              );
            }),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _Grafica(),
            Expanded(
              child: ListView.builder(
                  itemCount: socketService.bandas.length,
                  itemBuilder: (_, i) => _bandTile(socketService.bandas[i])),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => addNewBand(context),
        elevation: 1,
      ),
    );
  }

  addNewBand(BuildContext context) {
    final textController = new TextEditingController();
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Nombre Nueva Banda'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            child: Text('Agregar'),
            elevation: 5,
            onPressed: () {
              addBandToList(textController.text);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      Get.find<SocketService>().agregarBanda(name);
    }
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10),
        child: Text(
          'Eliminar Banda',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onDismissed: (_) => Get.find<SocketService>().eliminarBanda(band.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(
          band.name,
          style: TextStyle(fontSize: 20),
        ),
        trailing: Text(
          '${band.votes} ',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        onTap: () => Get.find<SocketService>().agregarVoto(band.id),
      ),
    );
  }
}

class _Grafica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = new Map();
    Get.find<SocketService>().bandas.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });

    return PieChart(dataMap: dataMap);
  }
}

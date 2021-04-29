import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names_app/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bans = [
    Band(id: '1', name: 'Banda 1', votes: 5),
    Band(id: '2', name: 'Banda 2', votes: 10),
    Band(id: '3', name: 'Banda 3', votes: 18),
    Band(id: '4', name: 'Banda 4', votes: 7),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HomePage',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: bans.length, itemBuilder: (_, i) => _bandTile(bans[i])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
        elevation: 1,
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();
    if (Platform.isAndroid) {
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
              onPressed: () => addBandToList(textController.text),
            )
          ],
        ),
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('Nombre Nueva Banda'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: false,
              child: Text('Agregar'),
              onPressed: () => addBandToList(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Cerrar'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      setState(() {
        this
            .bans
            .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      });
    }
    Navigator.pop(context);
  }

  Widget _bandTile(Band ban) {
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
      onDismissed: (_) {
        this.bans.remove(ban);
        setState(() {});
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(ban.name.substring(0, 2)),
        ),
        title: Text(
          ban.name,
          style: TextStyle(fontSize: 20),
        ),
        trailing: Text(
          '${ban.votes} ',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ),
    );
  }
}

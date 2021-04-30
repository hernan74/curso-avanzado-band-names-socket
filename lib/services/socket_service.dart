import 'package:band_names_app/models/band.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService extends ChangeNotifier {
  Rx<ServerStatus> _serverStatus = ServerStatus.Connecting.obs;
  IO.Socket _socket;
  RxList<Band> _bandas = <Band>[].obs;
  SocketService() {
    this._initConfig();
  }

  Rx<ServerStatus> get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  RxList<Band> get bandas => this._bandas;

  void _initConfig() {
    _socket = IO.io('https://curso-flutter-socket-server1.herokuapp.com/',
        OptionBuilder().setTransports(['websocket']).build());

    _socket.on('connect', (_) {
      print('conexion');
      this._serverStatus.value = ServerStatus.Online;
    });
    _socket.onDisconnect((_) {
      print('disconnect');
      this._serverStatus.value = ServerStatus.Offline;
    });
    _socket.on('mensaje', (payload) {
      print('nuevo-mensaje $payload');
    });
    _socket.on(
        'active-bands',
        (bandas) => {
              this._bandas.value =
                  (bandas as List).map((e) => Band.fromMap(e)).toList()
            });
  }

  void agregarVoto(String idBanda) {
    _socket.emit('vote-band', ({'id': idBanda}));
  }

  void agregarBanda(String nombre) {
    _socket.emit('add-band', ({'name': nombre}));
  }

  void eliminarBanda(String id) {
    _socket.emit('delete-band', ({'id': id}));
  }
}

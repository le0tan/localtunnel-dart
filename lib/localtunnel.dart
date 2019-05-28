/// Support for doing something awesome.
///
/// More dartdocs go here.
library localtunnel;

export 'src/localtunnel_base.dart';

// TODO: Export any libraries intended for clients of this package.

import 'dart:io';
import 'package:observable/observable.dart';

void main() async {
  
  ServerSocket clientSocket = await ServerSocket.bind('127.0.0.1', 23333);
  Socket localSocket = await Socket.connect('127.0.0.1', 3000);
  clientSocket.listen((Socket s) {
    s.listen((data) {
      localSocket.write(String.fromCharCodes(data).trim());
      // how do I send `data` via localSocket without closing it?

      // Then I need to forward the response from localsocket to `s`
      localSocket.listen((resp){
        s.write(resp);
      });
    }, onDone: () {
      print('s done');
      s.destroy();
    });
  }, onDone: () {
    print('clientSocket done');
    clientSocket.close();
  });
}

void handleClient(Socket client) {
  print('Connection from '
      '${client.remoteAddress.address}:${client.remotePort}');
  client.listen((data) {
    print(new String.fromCharCodes(data).trim());
    Socket.connect('127.0.0.1', 3000).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      socket.write(data);
      socket.listen((data) {});
      socket.close();
    });
  }, onDone: () {
    print('done');
    client.destroy();
  });
}

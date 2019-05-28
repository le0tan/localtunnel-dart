/// Support for doing something awesome.
///
/// More dartdocs go here.
library localtunnel;

export 'src/localtunnel_base.dart';

// TODO: Export any libraries intended for clients of this package.

import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';

void main() {
  String indexRequest = 'GET / HTTP/1.1\nConnection: close\n\n';

  // runZoned(() {
  //   HttpServer.bind('127.0.0.1', 3000).then((server) {
  //     print('Server running');
  //     server.listen((req) {
  //       print(req.headers);
  //     });
  //   });
  // });

  // // 7777 is localtunnel server's port
  // Socket.connect('127.0.0.1', 7777).then((socket) {
  //   print('Connected to: '
  //       '${socket.remoteAddress.address}:${socket.remotePort}');
  //   socket.listen((data) {
  //     print(new String.fromCharCodes(data).trim());
  //   }, onDone: () {
  //     print('done');
  //     socket.destroy();
  //   });
  // });

  // 23333 is localtunnel client's port
  ServerSocket.bind('127.0.0.1', 23333).then((ServerSocket server) {
    server.listen(handleClient);
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
      socket.close();
    });
  }, onDone: () {
    print('done');
    client.destroy();
  });
}

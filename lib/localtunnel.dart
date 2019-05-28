/// Support for doing something awesome.
///
/// More dartdocs go here.
library localtunnel;

export 'src/localtunnel_base.dart';

// TODO: Export any libraries intended for clients of this package.

import 'dart:io';

void main() {
  String indexRequest = 'GET / HTTP/1.1\nConnection: close\n\n';

  //connect to google port 80
  Socket.connect("google.com", 80).then((socket) {
    print('Connected to: '
        '${socket.remoteAddress.address}:${socket.remotePort}');

    //Establish the onData, and onDone callbacks
    socket.listen((data) {
      print(new String.fromCharCodes(data).trim());
    }, onDone: () {
      print("Done");
      socket.destroy();
    });

    //Send the request
    socket.write(indexRequest);
  });
}

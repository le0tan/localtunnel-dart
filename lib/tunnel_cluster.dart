import 'package:observable/observable.dart';
import 'package:localtunnel/tunnel_connection_model.dart';
import 'dart:io';

class TunnelCluster extends Observable {
  String remote_host;
  int remote_port;
  String local_host;
  int local_port;
  int tunnelCount;
  static TunnelCluster _tunnelCluster;
  TunnelConnectionModel _tunnelConnection;

  TunnelCluster._initTunnelCluster(TunnelConnectionModel tunnelConnection) {
    tunnelCount = 1;
    this._tunnelConnection = tunnelConnection;
  }

  static TunnelCluster getTunnelCluster(
      TunnelConnectionModel tunnelConnection) {
    if (_tunnelCluster == null) {
      _tunnelCluster = TunnelCluster._initTunnelCluster(tunnelConnection);
    }
    return _tunnelCluster;
  }

  void open() async {
    String remote_host = _tunnelConnection.remote_host;
    int remote_port = _tunnelConnection.remote_port;

    String local_host = "localhost"; //opt.local_host || "localhost";
    int local_port = 1234; //opt.local_port;

    print(
        "establishing tunnel $local_host:$local_port <-> $remote_host:$remote_port");

    // connection to localtunnel server
    Socket remote = await Socket.connect(remote_host, remote_port);
    Socket local = await Socket.connect(local_host, local_port);

    print("Sockets established.");
  }
}

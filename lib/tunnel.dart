import 'dart:io';
import 'package:dio/dio.dart';
import 'package:localtunnel/tunnel_cluster_event_type.dart';
import 'package:observable/observable.dart';
import 'package:localtunnel/tunnel_connection_model.dart';
import 'package:localtunnel/tunnel_connection_response_model.dart';
import 'package:localtunnel/tunnel_cluster.dart';
import 'package:localtunnel/tunnel_event.dart';

class Tunnel extends Observable {
  bool _closed;
  String _host;
  String _subdomain;
  int _tunnelCount;

  Tunnel(String host, String subdomain) {
    this._host = host;
    if (this._host == null) {
      this._host = "https://localtunnel.me";
    }
    this._subdomain = subdomain;
    this._closed = false;
  }

  void open() async {
    TunnelConnectionModel tunnelConnection;
    tunnelConnection = await _init();
    print(
        "connected to tunnel: https://${tunnelConnection.name}.${tunnelConnection.remote_host} at ${tunnelConnection.remote_port}");
    _establish(tunnelConnection);
  }

  Future<TunnelConnectionModel> _init() async {
    String baseUri = this._host + '/';

    String uri = baseUri + (_subdomain != null ? _subdomain : "?new");

    // URL upstream =new URL(uri);
    Uri upstream = Uri.parse(uri);
    Dio dio = Dio();
    print(uri);
    var resp = await dio.get(uri,
        options: Options(
            contentType: ContentType.json,
            connectTimeout: 5000,
            sendTimeout: 5000,
            responseType: ResponseType.json));
    print(resp.statusCode);
    if (resp.statusCode != 200) {
      throw new Exception(
          "localtunnel server returned an error, please try again");
    }

    Map<String, dynamic> data = resp.data;

    TunnelConnectionResponseModel tunnelConnectionResponse =
        TunnelConnectionResponseModel(
            data['port'], data['max_conn_count'], data['id'], data['url']);

    // int port = tunnelConnectionResponse.port;
    // String host = upstream.host;
    int max_conn = tunnelConnectionResponse.max_conn_count != null
        ? tunnelConnectionResponse.max_conn_count
        : 1;
    return new TunnelConnectionModel(
        upstream.host,
        tunnelConnectionResponse.port,
        tunnelConnectionResponse.id,
        tunnelConnectionResponse.url,
        max_conn);
  }

  void _establish(TunnelConnectionModel tunnelConnection) {
    TunnelCluster tunnelCluster =
        TunnelCluster.getTunnelCluster(tunnelConnection);
    tunnelCluster.changes.listen((data) {
      // what to do here???
      // maybe call update? and open a new tunnel?
    });

    _tunnelCount = 0;

    for (int i = 0; i < tunnelConnection.max_conn; i++) {
      tunnelCluster.open();
    }
  }

  Socket _socket;

  void close() {
    this._closed = true;
    _closeSocket();
  }

  void _closeSocket() {
    if (_socket != null) {
      try {
        _socket.close();
      } catch (e) {
        print(e);
      }
    }
  }

  void update(Observable arg0, Object arg1) {
    if (arg1 is TunnelEvent) {
      TunnelEvent tunnelEvent = arg1;
      switch (tunnelEvent.type) {
        case TunnelClusterEventType.OPEN:
          //once!
          //TODO
          //tunnel.emit(url)
          _tunnelCount++;
          this._socket = tunnelEvent.socket;
          if (_closed) {
            _closeSocket();
          }

          print("tunnel open [total: " + _tunnelCount.toString() + "]");
          break;
        case TunnelClusterEventType.ERROR:
          //TODO
          //self.emit(error)
          break;
        case TunnelClusterEventType.DEAD:
          break;
        case TunnelClusterEventType.REQUEST:
          break;
      }
    }
  }
}

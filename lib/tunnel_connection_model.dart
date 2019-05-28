class TunnelConnectionModel {
  String remote_host;
  int remote_port;
  String name;
  String url;
  int max_conn;

  TunnelConnectionModel(String remote_host, int remote_port, String name,
      String url, int max_conn) {
    this.remote_host = remote_host;
    this.remote_port = remote_port;
    this.name = name;
    this.url = url;
    this.max_conn = max_conn;
  }
}

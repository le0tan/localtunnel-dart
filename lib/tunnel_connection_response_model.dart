class TunnelConnectionResponseModel {
  int port;
  int max_conn_count;
  String id;
  String url;
  TunnelConnectionResponseModel(
      this.port, this.max_conn_count, this.id, this.url);
}

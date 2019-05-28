import 'package:localtunnel/tunnel_cluster_event_type.dart';
import 'dart:io';

class TunnelEvent {
  final TunnelClusterEventType type;

  final Socket socket;

  TunnelEvent(this.type, this.socket);
}

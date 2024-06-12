import 'package:socket_io_client/socket_io_client.dart';

import 'presence-channel.dart';
import 'socketio-private-channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPresenceChannel extends SocketIoPrivateChannel
    implements PresenceChannel {
  SocketIoPresenceChannel(
    Socket? socket,
    String name,
    Map<String, Object?> options,
  ) : super(socket, name, options);

  /// Register a callback to be called anytime the member list changes.
  SocketIoPresenceChannel here(Function callback) {
    on('presence:subscribed', (List<dynamic> members) {
      callback(members.map((m) => m['user_info']));
    });

    return this;
  }

  /// Listen for someone joining the channel.
  SocketIoPresenceChannel joining(Function callback) {
    on('presence:joining', (member) => callback(member['user_info']));

    return this;
  }

  /// Listen for someone leaving the channel.
  SocketIoPresenceChannel leaving(Function callback) {
    on('presence:leaving', (member) => callback(member['user_info']));

    return this;
  }
}

import 'package:socket_io_client/socket_io_client.dart';

import 'private-channel.dart';
import 'socketio-channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPrivateChannel extends SocketIoChannel implements PrivateChannel {
  SocketIoPrivateChannel(
    Socket? socket,
    String name,
    Map<String, Object?> options,
  ) : super(socket, name, options);

  /// Trigger client event on the channel.
  SocketIoPrivateChannel whisper(String eventName, dynamic data) {
    socket?.emit('client event', {
      'channel': name,
      'event': 'client-$eventName',
      'data': data,
    });

    return this;
  }
}

library laravel_echo2;

import 'package:socket_io_client/socket_io_client.dart';

import 'src/channel/channel.dart';
import 'src/channel/presence-channel.dart';
import 'src/channel/private-channel.dart';
import 'src/connector/socketio-connector.dart';

///
/// This class is the primary API for interacting with broadcasting.
///
class Echo {
  /// The broadcasting connector.
  late SocketIoConnector connector;

  /// Socket instance
  Socket? get socket => connector.socket;

  /// The Echo options.
  late Map<String, dynamic> options;

  /// Create a new class instance.
  Echo(this.options) {
    connect();
  }

  /// Get a channel instance by name.
  Channel? channel(String channel) {
    return connector.channel(channel);
  }

  /// Create a new connection.
  void connect() {
    if (options['broadcaster'] == 'socket.io') {
      connector = SocketIoConnector(options);
    } else if (options['broadcaster'] is Function) {
      connector = options['broadcaster'](options);
    } else {
      connector = SocketIoConnector(options);
    }
  }

  /// Disconnect from the Echo server.
  void disconnect() {
    connector.disconnect();
  }

  /// Get a presence channel instance by name.
  PresenceChannel? join(String channel) {
    return connector.presenceChannel(channel);
  }

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String channel) {
    connector.leave(channel);
  }

  /// Leave the given channel.
  void leaveChannel(String channel) {
    connector.leaveChannel(channel);
  }

  /// Listen for an event on a channel instance.
  Channel listen(String channel, String event, Function callback) {
    return connector.listen(channel, event, callback);
  }

  /// Get a private channel instance by name.
  PrivateChannel? private(String channel) {
    return connector.privateChannel(channel);
  }
  //TODO remove comment
  /// Get a private encrypted channel instance by name.
  // PrivateChannel? encrypted(String channel) {
  //   return this.connector?.encryptedPrivateChannel(channel);
  // }

  /// Get the Socket ID for the connection.
  String? sockedId() {
    return connector.socketId();
  }
}

import 'package:socket_io_client/socket_io_client.dart';
import '../channel/socketio-channel.dart';
import '../channel/socketio-presence-channel.dart';
import '../channel/socketio-private-channel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'connector.dart';

///
/// This class creates a connnector to a Socket.io server.
///
class SocketIoConnector extends Connector {
  /// The Socket.io connection instance.
  Socket? socket;

  /// All of the subscribed channel names.
  Map<String, dynamic> channels = {};

  SocketIoConnector(Map<String, dynamic> options) : super(options);

  /// Create a fresh Socket.io connection.
  @override
  void connect() {
    final io = IO.io;

    socket = io(options['host'], options);

    socket?.connect();

    // return this.socket;
  }
  //TODO I removed it
  // / Get socket.io module from options.
  // dynamic getSocketIO() {
  //   if (this.options['client'] != null) {
  //     return this.options['client'];
  //   }

  //   throw Exception(
  //       'Socket.io client not found. Should be passed via options.client');
  // }

  /// Listen for an event on a channel instance.
  SocketIoChannel listen(String name, String event, Function callback) {
    return channel(name)!.listen(event, callback);
  }

  /// Get a channel instance by name.
  @override
  SocketIoChannel? channel(String name) {
    // if (channels[name] == null) {
    return channels[name] ??= SocketIoChannel(socket, name, options);
    // }

    // return channels[name];
  }

  /// Get a private channel instance by name.
  @override
  SocketIoPrivateChannel? privateChannel(String name) {
    // if (channels['private-$name'] == null) {
    return channels['private-$name'] ??= SocketIoPrivateChannel(
      socket,
      'private-$name',
      options,
    );
    // }

    // return channels['private-$name'];
  }

  /// Get a presence channel instance by name.
  @override
  SocketIoPresenceChannel? presenceChannel(String name) {
    // if (channels['presence-$name'] == null) {
    return channels['presence-$name'] ??= SocketIoPresenceChannel(
      socket,
      'presence-$name',
      options,
    );
    // }

    // return channels['presence-$name'];
  }

  /// Leave the given channel, as well as its private and presence variants.
  @override
  void leave(String name) {
    final channels = [name, 'private-$name', 'presence-$name'];

    channels.forEach((name) {
      leaveChannel(name);
    });
  }

  /// Leave the given channel.
  @override
  void leaveChannel(String name) {
    if (channels[name] != null) {
      channels[name].unsubscribe();
      channels.remove(name);
    }
  }

  /// Get the socket ID for the connection.
  @override
  String? socketId() {
    return socket?.id;
  }

  /// Disconnect Socketio connection.
  @override
  void disconnect() {
    socket?.disconnect();
  }
}

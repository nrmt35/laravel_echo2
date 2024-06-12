import 'package:socket_io_client/socket_io_client.dart';
import '../util/event-formatter.dart';

import 'channel.dart';

///
/// This class represents a Socket.io channel.
///
class SocketIoChannel extends Channel {
  /// The Socket.io client instance.
  final Socket? socket;

  /// The name of the channel.
  final String name;

  /// Channel options.
  final Map<String, dynamic> options;

  /// The event formatter.
  late EventFormatter eventFormatter;

  /// The event callbacks applied to the channel.
  Map<String, dynamic> events = {};

  /// Create a new class instance.
  SocketIoChannel(this.socket, this.name, this.options) {
    this.eventFormatter = EventFormatter(options['namespace']);

    subscribe();
    configureReconnector();
  }

  /// Subscribe to a Socket.io channel.
  void subscribe() {
    socket?.emit(
      'subscribe',
      {
        'channel': name,
        'auth': options['auth'] ?? {},
      },
    );
  }

  /// Unsubscribe from channel and ubind event callbacks.
  void unsubscribe() {
    unbind();

    socket?.emit(
      'unsubscribe',
      {
        'channel': name,
        'auth': options['auth'] ?? {},
      },
    );
  }

  /// Listen for an event on the channel instance.
  SocketIoChannel listen(String event, Function callback) {
    on(eventFormatter.format(event), callback);

    return this;
  }

  /// Stop listening for an event on the channel instance.
  @override
  SocketIoChannel stopListening(String event) {
    final name = eventFormatter.format(event);
    socket?.off(name);
    events.remove(name);

    return this;
  }

  /// Register a callback to be called anytime a subscription succeeds.
  SocketIoChannel subscribed(Function callback) {
    on('connect', (socket) => callback(socket));

    return this;
  }

  /// Register a callback to be called anytime an error occurs.
  SocketIoChannel error(Function callback) {
    return this;
  }

  /// Bind the channel's socket to an event and store the callback.
  void on(String event, Function callback) {
    final listener = (data) {
      if (name == data[0]) {
        callback(data[1]);
      }
    };

    socket?.on(event, listener);
    bind(event, listener);
  }

  /// Attach a 'reconnect' listener and bind the event.
  void configureReconnector() {
    final listener = (_) {
      subscribe();
    };

    socket?.on('reconnect', listener);
    bind('reconnect', listener);
  }

  /// Bind the channel's socket to an event and store the callback.
  void bind(String event, Function callback) {
    events[event] ??= [];
    events[event].add(callback);
  }

  /// Unbind the channel's socket from all stored event callbacks.
  void unbind() {
    events.keys.forEach((event) {
      events[event].forEach((callback) {
        socket?.off(event, callback);
      });

      events[event] = null;
    });
  }
}

import 'package:nutritionapp/common/constants.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  final Function(String) onMessageReceived;
  late IOWebSocketChannel _channel;

  WebSocketManager._({required this.onMessageReceived}) {
    _channel = IOWebSocketChannel.connect(AppConstants.webSocketUrl);
    _setupWebSocketListener();
  }

  factory WebSocketManager({required Function(String) onMessageReceived}) {
    return WebSocketManager._(onMessageReceived: onMessageReceived);
  }

  void _setupWebSocketListener() {
    _channel.stream.listen(
      (message) {
        onMessageReceived(message);
      },
      onDone: () {
        print('WebSocket closed');
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      cancelOnError: true,
    );
  }

  void disconnect() {
    _channel.sink.close();
  }
}

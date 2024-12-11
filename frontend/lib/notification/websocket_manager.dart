import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String userId;
  WebSocketChannel? _channel;

  WebSocketManager({required this.userId});

  // WebSocket 연결
  void connect(void Function(String) onMessageReceived) {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://3.34.5.57/notifications/ws?user_id=$userId'),
    );

    // 메시지 수신 처리
    _channel!.stream.listen((message) {
      print("WebSocket 메시지 수신: $message");
      onMessageReceived(message);
    }, onError: (error) {
      print("WebSocket 에러: $error");
    }, onDone: () {
      print("WebSocket 연결 종료");
    });
  }

  // WebSocket 연결 종료
  void disconnect() {
    _channel?.sink.close();
    print("WebSocket 연결이 종료되었습니다.");
  }
}

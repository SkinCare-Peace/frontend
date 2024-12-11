import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'notifications.dart';
import 'package:frontend/Constants/user_data.dart'; // Ensure this file contains the UserData class

class WebSocketNotificationApp extends StatefulWidget {
  final UserData userData;

  WebSocketNotificationApp({required this.userData});

  @override
  _WebSocketNotificationAppState createState() =>
      _WebSocketNotificationAppState();
}

class _WebSocketNotificationAppState extends State<WebSocketNotificationApp> {
  late WebSocketChannel channel;
  late NotificationService notificationService;

  @override
  void initState() {
    super.initState();

    // NotificationService initialization
    notificationService = NotificationService();

    // Retrieve user ID from UserData
    String userId = widget.userData.id;

    // Connect to WebSocket with the user ID
    channel = WebSocketChannel.connect(
      Uri.parse('ws://3.34.5.57/notifications/ws?user_id=$userId'),
    );

    // WebSocket message listener
    channel.stream.listen((message) {
      handleWebSocketMessage(message);
    });
  }

  // Handle WebSocket messages
  void handleWebSocketMessage(String message) {
    final data = json.decode(message);
    String title = data['title'];
    String body = data['body'];
    String image = data['image'];

    // Show notification
    notificationService.showNotification(title, body, image);
  }

  @override
  void dispose() {
    channel.sink.close(); // Close WebSocket connection
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Notifications')),
      body: Center(child: Text('Listening for notifications...')),
    );
  }
}

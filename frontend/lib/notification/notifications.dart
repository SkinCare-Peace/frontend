import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  // 초기화
  Future<void> _initializeNotifications() async {
    const androidSetting = AndroidInitializationSettings('app_icon');
    const initializationSettings =
        InitializationSettings(android: androidSetting);
    await _notifications.initialize(initializationSettings);
  }

  // 알림 표시
  Future<void> showNotification(String title, String body, String image) async {
    final androidDetails = AndroidNotificationDetails(
      'unique_channel_id', // 채널 ID
      'Notification Type', // 채널 이름
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(image), // 이미지 파일
        contentTitle: title,
        summaryText: body,
      ),
    );

    final details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0, // 알림 ID
      title, // 제목
      body, // 내용
      details,
    );
  }
}

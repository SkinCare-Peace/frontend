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
    print("알림 표시: $title, $body, $image");
    String path = "assets/$image.png";
    final androidDetails = AndroidNotificationDetails(
      'unique_channel_id', // 채널 ID
      'Notification Type', // 채널 이름
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: image.isNotEmpty
          ? BigPictureStyleInformation(
              DrawableResourceAndroidBitmap(image), // 이미지
              largeIcon: DrawableResourceAndroidBitmap(image), // 아이콘
            )
          : null, // 이미지가 없으면 기본 텍스트 알림
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

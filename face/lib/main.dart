import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'camera_demo.dart';

// 메인 함수: 앱 실행 시작 지점
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 위젯 바인딩 초기화
  // 사용 가능한 카메라 목록을 가져옴
  final cameras = await availableCameras();
  // 첫 번째 카메라를 기본값으로 선택하여 앱 실행
  runApp(MyApp(cameras: cameras));
}

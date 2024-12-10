 import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/logIn/log_in.dart';


List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      /** home 변경할때, 주석처리로! **/
      home: const LoginPage(), // 로그인 페이지
    );
  }
}
// 67581540629bc4b679480225

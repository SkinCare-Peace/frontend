import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/loading/loading_page.dart';

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
      //home 변경할때, 주석처리로!
      home: SkinStatusPage(), //처음 로딩화면
      //home: RoutineCreatePage(), //루틴 생성중 로딩 페이지로 바로 이동
    );
  }
}

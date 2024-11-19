import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/addProduct/add_main.dart';
import 'package:frontend/loading/loading_page0.dart';
import 'package:frontend/loading/loading_page1.dart';
import 'package:frontend/loading/loading_page2.dart';
import 'package:frontend/logIn/log_in.dart';
import 'package:frontend/routines/routine_create.dart';

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
      //home: LoadingPage0(), //로딩 페이지 0
      home : LoadingPage1(),
      //home: LoginPage(), // 로그인 페이지
      //home: RoutinePage() // 루틴 페이지
      //home : const AddSkinCareMain() // 제품 등록 페이지
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:frontend/loading/loading_page.dart';
import'home_page.dart';

List<CameraDescription>cameras=[];
void main() async{
WidgetsFlutterBinding.ensureInitialized();
cameras=await availableCameras();
 runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Flutter demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: SkinStatusPage(),
      //home: HomePage(),  //카메라용 홈페이지
    );
  }

}
// 깃 푸시 확인용 10/6. 10pm20
//  google_mlkit_face_detection 버전 높혀서 수정함

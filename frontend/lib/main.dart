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
      home: SkinStatusPage(), //새 페이지 만들면 주석처리하구 하면됨용~
      //home: HomePage(), //얼굴인식 확인용 홈페이지 
    );
  }

}


import 'dart:io'; // 플랫폼 구분을 위해 사용
import 'package:flutter/material.dart'; // Flutter의 기본 위젯과 기능 사용
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // 카메라 기능을 위한 패키지
// 플랫폼별 서비스와 통신하기 위함
import 'package:flutter/services.dart';

// MyApp 위젯: StatefulWidget으로 카메라 기능을 포함
class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.cameras});

  final List<CameraDescription> cameras; // 사용 가능한 카메라 목록

  @override
  MyAppState createState() => MyAppState(); // 상태를 관리하는 State 생성
}

// MyAppState 클래스: 실제 상태와 로직을 관리
class MyAppState extends State<MyApp> {
  CameraController? _controller; // nullable로 선언
  late Future<void> _initializeControllerFuture; // 카메라 초기화 Future
  late int selectedCameraIndex; // 선택된 카메라의 인덱스

  final InputImage inputImage;

  @override
  void initState() {
    super.initState();
    // 첫 번째 카메라를 기본값으로 설정
    selectedCameraIndex = 0;
    // 초기 카메라 컨트롤러 초기화
    _initCameraController(widget.cameras[selectedCameraIndex]);
  }

  // 카메라 컨트롤러를 초기화하는 함수
  void _initCameraController(CameraDescription cameraDescription) {
    // 기존 컨트롤러가 존재하면 해제
    _controller?.dispose();
    // 새로운 컨트롤러 생성
    _controller = CameraController(
      enableAudio: false, // 오디오 캡쳐 비활성화
      cameraDescription, // 사용가능한 카메라
      ResolutionPreset.max, // 해상도
      imageFormatGroup: Platform.isAndroid // 플랫폼에 따라 이미지 포맷 설정
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );
    // 컨트롤러 초기화 수행
    _initializeControllerFuture = _controller!.initialize(); // 초기화할 때 null 체크
  }

  // 장치 방향을 각도로 정의한 매핑한 맵 정의
// ML Kit에서 이미지의 회전을 보정하기 위해 사용
final _orientations = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

  @override
  void dispose() {
    // 위젯이 제거될 때 컨트롤러 해제
    _controller?.dispose(); // nullable 변수이므로 null 체크 후 해제
    super.dispose();
  }

  // 카메라 변경 시 호출되는 함수
  void onSwitchCamera() {
    // 카메라 인덱스 변경
    selectedCameraIndex = (selectedCameraIndex + 1) % widget.cameras.length;
    // 새로운 카메라로 컨트롤러 초기화
    _initCameraController(widget.cameras[selectedCameraIndex]);
    // 상태 변경 알림
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Camera Demo')), // 상단 앱바 제목 설정
        body: Center(
          // 가운데 정렬
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture, // 카메라 초기화 Future
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // 초기화가 완료되면 카메라 미리보기 화면 출력
                      return _controller != null
                          ? CameraPreview(_controller!)
                          : Container();
                    } else {
                      // 초기화 중이면 로딩 인디케이터 표시
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              // 카메라 변경 버튼
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: onSwitchCamera,
                  child: const Text('카메라 전환'),
                ),
              ),
            ],
          ),
        ),
        // // 플로팅 액션 버튼: 카메라 캡처 기능
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     try {
        //       // 카메라가 초기화될 때까지 대기
        //       await _initializeControllerFuture;
        //       // 현재 화면을 캡처하여 이미지로 저장
        //       final image = await _controller!.takePicture();

        //       if (!mounted) return; // 위젯이 마운트되어 있는지 확인

        //       // 캡처한 이미지를 표시하는 새로운 화면으로 이동
        //       await Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => DisplayPictureScreen(
        //             imagePath: image.path, // 이미지 경로 전달
        //           ),
        //         ),
        //       );
        //     } catch (e) {
        //       // 에러 발생 시 콘솔에 출력
        //       print(e);
        //     }
        //   },
        //   child: const Icon(Icons.camera_alt), // 버튼 아이콘 설정
        // // ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.centerFloat, // 버튼 위치 조정
      ),
    );
  }
}

// // --------------------------------
// // 찍은 사진을 보여주는 화면을 위한 위젯
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath; // 이미지 파일의 경로

//   const DisplayPictureScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('캡쳐 화면')), // 상단 앱바 제목 설정
//       // 이미지 파일을 불러와서 화면에 표시
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
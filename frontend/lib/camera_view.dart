import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';


//카메라 뷰
class CameraView extends StatefulWidget {
  final String title;
  final CustomPaint? customPaint; // 얼굴 인식 결과 그리기 
  final String? text; //얼굴 인식 결과 텍스트
  final Function(InputImage inputImage) onImage; //이미지 처리 콜백함수
  final CameraLensDirection initialDirection; //초기 카메라 렌즈 방향

  const CameraView({
    super.key,
    required this.title,
    required this.onImage,
    required this.initialDirection,
    this.customPaint,
    this.text,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  int _cameraIndex = 0;

  @override
  void initState() {
    super.initState();

    // 초기 카메라 렌즈 방향에 맞는 카메라 인덱스 설정
    _cameraIndex = cameras.indexWhere((camera) =>
        camera.lensDirection == widget.initialDirection);

    if (_cameraIndex == -1 && cameras.isNotEmpty) {
      _cameraIndex = 0; // 기본적으로 첫 번째 카메라 사용
    }

    _startLive(); //라이브 시작 
  }

  Future<void> _startLive() async {
    try {
      final camera = cameras[_cameraIndex];
      _controller = CameraController(
        camera,
        ResolutionPreset.high, //해상도 최대한 높게 
        enableAudio: false, //오디오 ㄴ 
      );

      await _controller?.initialize();

      if (!mounted) return;

      // 이미지 스트림 시작
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
    }
  }

//카메라에서 받은 이미지 처리 함수 
  Future<void> _processCameraImage(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final camera = cameras[_cameraIndex];
      final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
          InputImageRotation.rotation0deg;

      final inputImageMetadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: InputImageFormat.nv21, bytesPerRow: 0,
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: inputImageMetadata,
      );

      widget.onImage(inputImage); // 이미지 처리 콜백 함수 호출
    } catch (e) {
      if (kDebugMode) {
        print('Error processing image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(-1.0, 1.0), // 화면 전체 좌우 반전
      child: _body(),
    ),
    );
  }

  Widget _body() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator()); //카메라 초기화 중일떄 로딩 
    }

    return Stack(
      fit: StackFit.expand, 
      children: [
        
        CameraPreview(_controller!), //카메라 프리뷰
        if (widget.customPaint != null) widget.customPaint!, //얼굴 인식 결과 
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
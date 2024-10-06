import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class CameraView extends StatefulWidget {
  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

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

    _startLive();
  }

  // 실시간 카메라 시작 메소드
  Future<void> _startLive() async {
    try {
      final camera = cameras[_cameraIndex];
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller?.initialize();

      if (!mounted) return;

      // 이미지 스트림 시작
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    } catch (e) {
      // 카메라 초기화나 스트림 시작 중 에러 처리
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
    }
  }

  // 실시간 카메라 이미지 처리 메소드
  Future<void> _processCameraImage(CameraImage image) async {
    try {
      // 카메라 이미지에서 바이너리 데이터 추출
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      // 이미지 크기 및 회전 정보 설정
      final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final camera = cameras[_cameraIndex];
      final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
          InputImageRotation.rotation0deg;

      // InputImageMetadata 생성
      final inputImageMetadata = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: InputImageFormat.nv21, bytesPerRow: 0, // bytes per Row 오류때매 일단 삭제함 
      );

      // InputImage 생성
      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: inputImageMetadata,
      );

      widget.onImage(inputImage); // 이미지 처리 콜백 함수 호출
    } catch (e) {
      // 이미지 처리 중 에러 처리
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
      body: _body(),
    );
  }

  Widget _body() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return CameraPreview(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

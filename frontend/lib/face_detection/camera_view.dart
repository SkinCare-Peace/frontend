import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    // 전면 카메라 검색
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    // 전면 카메라로 설정
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false, // 오디오 비활성화
    );

    await _controller?.initialize();
    setState(() {});
  }

  Future<String?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print('Camera is not initialized.');
      return null;
    }

    try {
      final file = await _controller!.takePicture();
      return file.path; // 사진 경로 반환
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(-1.0, 1.0), // 좌우 반전 적용
      child: CameraPreview(_controller!),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

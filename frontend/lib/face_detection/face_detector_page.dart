import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/face_detection/toServer.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // ML Kit import
import 'camera_view.dart';
import 'bbox.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({super.key});

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final GlobalKey<CameraViewState> _cameraViewKey = GlobalKey();

  // 얼굴 탐지
  Future<List<Face>> detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false, 
        enableLandmarks: false,
        performanceMode: FaceDetectorMode.fast, // 빠른 모드
      ),
    );

    final faces = await faceDetector.processImage(inputImage);
    return faces;
  }

  // 사진 촬영 및 서버 전송
  Future<void> _captureAndSend() async {
    if (_cameraViewKey.currentState != null) {
      final filePath = await _cameraViewKey.currentState!.takePicture();
      if (filePath != null) {
        final imageFile = File(filePath);

        // 얼굴 탐지
        final faces = await detectFaces(imageFile);

        if (faces.isNotEmpty) {
          for (var i = 0; i < faces.length; i++) {
            final regions = extractFaceRegions(faces[i]);

            for (var areaName in regions.keys) {
              final boundingBox = regions[areaName]!;
              print('Sending $areaName with bbox: ${boundingBox.toString()}');

              // 서버로 전송
              await sendFaceDataToServer(areaName, boundingBox, imageFile);
            }
          }
        } else {
          print('No faces detected.');
        }
      } else {
        print('Failed to take picture.');
      }
    } else {
      print('Camera is not initialized.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: CameraView(
              key: _cameraViewKey,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                onPressed: _captureAndSend,
                child: const Text('찰칵'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

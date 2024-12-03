
import 'dart:convert';
import 'package:frontend/addProduct/add_main.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/face_detection/face_detector_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'camera_view.dart';


//  서버로 얼굴 전체 bbox 전송
Future<void> sendFaceDataToServer(List<Face> faces) async {
  const String url = 'https://your-backend-url.com/face-data';

  // 얼굴 전체 바운딩 박스 정보만 전송
  List<Map<String, dynamic>> faceData = faces.map((face) {
    final boundingBox = face.boundingBox;

    return {
      'boundingBox': boundingBoxToJson(boundingBox),
      'eulerAngles': {
        'x': face.headEulerAngleX,
        'y': face.headEulerAngleY,
        'z': face.headEulerAngleZ,
      },
    };
  }).toList();

  // POST 요청
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'faces': faceData}),
    );

    if (response.statusCode == 200) {
      print('Face data sent successfully');
    } else {
      print('Failed to send face data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending face data: $e');
  }
}

Map<String, dynamic> boundingBoxToJson(Rect boundingBox) {
  return {
    'left': boundingBox.left,
    'top': boundingBox.top,
    'right': boundingBox.right,
    'bottom': boundingBox.bottom,
    'width': boundingBox.width,
    'height': boundingBox.height,
  };
}

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({super.key});

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );

  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CameraView(
                  customPaint: _customPaint,
                  text: _text,
                  onImage: (inputImage) {
                    processImage(inputImage);
                  },
                  initialDirection: CameraLensDirection.front,
                  title: '',
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '얼굴이 인식되면\n‘찰칵’ 버튼을 눌러주세요!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddSkinCareMain()), // 결과 페이지로 넘어가야함 임시로 제품추가로 건너뜀
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      elevation: 10,
                      shadowColor: Colors.black,
                    ),
                    child: const Text(
                      '찰칵',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    setState(() {
      _text = '';
    });

    final faces = await _faceDetector.processImage(inputImage);

    // 얼굴 전체 바운딩 박스 정보만 서버로 전송
    await sendFaceDataToServer(faces);

    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
      );
      setState(() {
        _customPaint = CustomPaint(painter: painter);
      });
    } else {
      setState(() {
        _customPaint = null;
        _text = 'Faces found: ${faces.length}\n\n';
      });
    }

    _isBusy = false;
  }
}





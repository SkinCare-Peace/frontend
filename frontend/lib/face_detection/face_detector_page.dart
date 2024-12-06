import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/face_detection/bboxToString.dart';
import 'package:frontend/face_detection/face_result.dart';
import 'package:frontend/loading/loading_face_result.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'camera_view.dart';
import 'toserver.dart';
import 'bbox.dart';
import 'package:http/http.dart' as http;
class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({super.key});

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final GlobalKey<CameraViewState> _cameraViewKey = GlobalKey();
  int _successfulResponses = 0; // 성공적인 응답 수 추적용
  final int _totalRequests = 9; // 요청 총 개수

  // 얼굴 탐지
  Future<List<Face>> detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );

    final faces = await faceDetector.processImage(inputImage);
    return faces;
  }

  // 요청 성공 시 카운트 증가 및 완료 확인
  void _onResponseSuccess() {
    setState(() {
      _successfulResponses++;
      if (_successfulResponses == _totalRequests) {
        _navigateToBSTI(); // 9개의 응답이 모두 성공하면 BSTI 화면으로 이동
      }
    });
  }

  // BSTI 화면으로 이동
  void _navigateToBSTI() {
    print('Navigating to BSTI screen...');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BSTI(),
      ),
    );
  }

  // 사진 촬영 및 서버 전송
  Future<void> _captureAndSend() async {
    if (_cameraViewKey.currentState != null) {
      final filePath = await _cameraViewKey.currentState!.takePicture();
      if (filePath != null) {
        final imageFile = File(filePath);


        try {
          // 얼굴 탐지
          final faces = await detectFaces(imageFile);
          if (faces.isNotEmpty) {

        // 로딩 페이지 표시
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  LoadingFaceResult(),
          ),
        );
            for (var i = 0; i < faces.length; i++) {
              final regions = extractFaceRegionsWithLandmarks(faces[i]);

              for (var areaName in regions.keys) {
                final boundingBox = regions[areaName]!;
                print('Sending $areaName with bbox: ${boundingBox.toString()}');

                // 서버로 데이터 전송
                await _sendDataToServer(areaName, boundingBox, imageFile);
              }
            }
          } else {
            print('No faces detected.');
            _showNoFaceDetectedPopup();
          }
        } catch (e) {
          print('Error: $e');
        }
      } else {
        print('Failed to take picture.');
      }
    } else {
      print('Camera is not initialized.');
    }
  }
  // 얼굴 미감지 팝업
void _showNoFaceDetectedPopup() {
  showDialog(
    context: context,
    barrierDismissible: true, // 팝업 바깥 클릭 시 닫기
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          '얼굴이 감지되지 않았습니다',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const Text(
          '얼굴을 가이드라인에 맞춰서 \n다시 시도해보세요!',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
            },
            child: const Text(
              '확인',
              style: TextStyle(
                color: Color.fromARGB(255, 87, 204, 222), // 버튼 색상
              ),
            ),
          ),
        ],
      );
    },
  );
}

  // 서버로 데이터 전송
  Future<void> _sendDataToServer(String areaName, Rect boundingBox, File imageFile) async {
    final url = Uri.parse('http://3.34.5.57/predict/$areaName');
    final bboxString = boundingBoxToString(boundingBox);
    
    try {
    final request = http.MultipartRequest('POST', url)
      ..fields['bbox'] = bboxString
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
      

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();


      if (response.statusCode == 200) {
        print('####### $areaName 데이터 전송 성공');
         print('####### 응답 body: $responseBody');
        _onResponseSuccess(); // 응답 성공 시 호출
      } else {
        print('####### $areaName 데이터 전송 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('####### $areaName 요청 실패: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        Expanded(
          flex: 0,
          child: CameraView(
            key: _cameraViewKey,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 안내문 텍스트
                const Padding(
                  padding: EdgeInsets.only(bottom: 25), 
                  child: Text(
                    '정면으로 가이드라인 안에 얼굴을 맞추고 \n"찰칵" 버튼을 눌러주세요!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color.fromARGB(178, 0, 0, 0), // 안내문 색상
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // '찰칵' 버튼
                ElevatedButton(
                  onPressed: _captureAndSend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222), 
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    '찰칵',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
}
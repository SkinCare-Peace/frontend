import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart'; // UserData import
import 'package:frontend/face_detection/face_result.dart';
import 'package:frontend/loading/loading_face_result.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'camera_view.dart';
import 'toserver.dart';
import 'bbox.dart';
import 'package:http/http.dart' as http;

class FaceDetectorPage extends StatefulWidget {
  final UserData userData; 

  const FaceDetectorPage(this.userData, {super.key});

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

  // 요청 성공 시 카운트 증r가 
  void _onResponseSuccess() {
    setState(() {
      _successfulResponses++;
      if (_successfulResponses == _totalRequests) {
        _navigateToBSTI(); // 9개응답 성공시 BSTI 화면으로 이동
      }
    });
  }

  // BSTI 화면으로 이동
  void _navigateToBSTI() {
    print('Navigating to BSTI screen...');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BSTI(widget.userData), // UserData 전달
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
                builder: (context) => LoadingFaceResult(),
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
  Future<void> _sendDataToServer(
      String areaName, Rect boundingBox, File imageFile) async {
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
      body: Stack(
        children: [
          // 카메라 화면
          CameraView(
            key: _cameraViewKey,
          ),
          // 흐림 처리 + 타원 가이드라인
          ClipPath(
            clipper: OvalClipper(), // 타원 모양 클리퍼
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // 흐림 강도
              child: Container(
                color: Colors.black.withOpacity(0.1), // 흐림 위에 반투명 검은색
              ),
            ),
          ),
          // 하단 텍스트 및 버튼
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Text(
                      '정면으로 가이드라인 안에 얼굴을 맞추고\n"찰칵" 버튼을 눌러주세요!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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

// 타원 바깥 부분 클리핑을 위한 CustomClipper
class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height)) // 전체 화면
      ..addOval(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2 - 100), // 타원 위치
          width: 300,
          height: 400,
        ),
      )
      ..fillType = PathFillType.evenOdd; // 타원 바깥 영역만 클립
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

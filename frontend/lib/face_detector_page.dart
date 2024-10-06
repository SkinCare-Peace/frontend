import 'package:camera/camera.dart'; // 카메라
import 'package:frontend/util/face_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // ml_kit
import 'camera_view.dart';

// 얼굴 감지 페이지 
class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectionPageState();
}

// 상태 관리 
class _FaceDetectionPageState extends State<FaceDetectorPage> {
  /// 얼굴 인식 객체 생성 부분 ///
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true, // 얼굴 윤곽선 감지
      enableClassification: true, // 얼굴 감정 분류 기능 활성화
    ),
  );

  bool _canProcess = true; // 이미지 처리 가능 여부
  bool _isBusy = false; // 이미지가 처리 중인지 여부
  CustomPaint? _customPaint; // 페인터
  String? _text; // 얼굴 감지 결과 텍스트

  @override
  void dispose() {
    _canProcess = false; // 이미지 처리를 중단
    _faceDetector.close(); // 얼굴 인식 객체 자원 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: _customPaint, // 얼굴 페인터
      text: _text, // 감지된 얼굴 정보 텍스트
      onImage: (inputImage) {
        processImage(inputImage); // 이미지 받아서 얼굴 인식 처리
      },
      initialDirection: CameraLensDirection.front, // 처음은 정면 카메라 사용
    );
  }

  // 이미지 처리 후 얼굴 인식하는 부분
  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return; // 이미지 처리를 중단할 수 있으면 바로 반환
    if (_isBusy) return; // 현재 이미지 처리가 진행 중이면 바로 반환
    _isBusy = true; // 이미지 처리 중 상태로 설정

    setState(() {
      _text = ''; // 텍스트 초기화
    });

    // 얼굴 인식 처리
    final faces = await _faceDetector.processImage(inputImage); // 이미지에서 얼굴 감지

    // 감지된 얼굴을 화면에 그리기
    final painter;
    final inputImageData = inputImage.metadata; // 이미지의 메타데이터 가져오기
    if (inputImageData != null) {
      painter = FaceDetectorPainter(
        faces,
        inputImageData.size, // 이미지 크기
        inputImageData.rotation, // 이미지 회전 각도
      );
      _customPaint = CustomPaint(painter: painter); // 페인터 적용
    } else {
      // 이미지 데이터가 없을 경우, 텍스트로만 출력
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'Face: ${face.boundingBox}\n\n'; // 각 얼굴의 boundingBox 표시
      }
      _text = text;
      _customPaint = null; // 페인터 없음
    }

    _isBusy = false; // 이미지 처리 완료
    if (mounted) {
      setState(() {}); // UI 업데이트
    }
  }
}

import 'package:camera/camera.dart'; //카메라 
import 'package:frontend/util/face_detector_painter.dart'; 
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; //ml_kit
import 'camera_view.dart';


// 얼굴 감지 페이지 
class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectionPageState();
}

//상태 관리 
class _FaceDetectionPageState extends State<FaceDetectorPage> {
  /// 얼굴 인식 객체 생성 부분 ///
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true, //얼굴 윤곽선 감지
      enableClassification: true, //얼굴 감정 분류 기능 활성화 
    ),
  );

  bool _canProcess = true; //이미지 처리 계속 할수 있는지 여부
  bool _isbusy = false; //현재 이미지가 처리중인지 나타내는 플래그 
  CustomPaint? _customPaint; //페인터
  String? _text; //얼굴 감지 결과 텍스트로하는 용


  @override
  void dispose() {
    _canProcess = false; //이미지 더 처리 안함
    _faceDetector.close(); //얼굴인식 객체 닫음 -> 자원 해제 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Face Detector',
      customPaint: _customPaint, //얼굴 페인터
      text: _text, //감지된 얼굴 정보 텍스트 표시
      onImage: (inputImage) {
        processImage(inputImage); //이미지 받으면 얼굴 인식 처리
      },
      initialDirection: CameraLensDirection.front, //초기는 정면
    );
  }

//이미지 처리해서 얼굴 인식하는 부분
  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return; // 이미지 처리를 중단할 수 있으면 바로 반환
    if (_isbusy) return; //이미 이미지 처리가 진행 중이면 바로 반환
    _isbusy = true; // 이미지 처리가 시작됨을 나타내기
    setState(() {
      _text = ''; //텍스트 초기화
    });
    //얼굴 인식처리
    final faces = await _faceDetector.processImage(inputImage); //이미지에서 얼굴 감지

    //감지된 얼굴을 화면에 그리기
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) { //이미지 데이터가 존재하면 페인터 생성
      final painter = FaceDetectorPainter(
        faces,//감지된 얼굴 목록
        inputImage.inputImageData!.size, //이미지 크기
        inputImage.inputImageData!.imageRotation, //회전 각도
        inputImage.filePath, //인자 4개 전달떄문에 임시로 추가
      );
      _customPaint = CustomPaint(painter: painter); //페인터 적용
    } else { //이미지 데이터 없는 경우 
      String text = 'faces found: ${faces.length}\n\n'; //감지된 얼굴 수 표시
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n'; //각 얼굴 boundingbox 표시
      }
      _text = text;
      _customPaint = null;
    }
    _isbusy = false; //이미지 처리 완료
    if (mounted) {
      setState(() {}); // UI 업데이트
    }
  }
}

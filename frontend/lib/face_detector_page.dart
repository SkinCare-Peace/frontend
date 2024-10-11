import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/util/face_detector_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'camera_view.dart';
/* 얼굴의 각 영역을 정의 -> 그에 맞는 좌표를 계산(각 영역을 구성하는 기준을 landmark로 나눔)
-> 각 영역에 해당하는 좌표 추출 및 전송 */

Future<void> sendFaceDataToServer(List<Face> faces) async {
  const String url = 'https://your-backend-url.com/face-data';

  // 얼굴 정보 리스트 생성
  List<Map<String, dynamic>> faceData = faces.map((face) {
    final boundingBox = face.boundingBox;

    // 랜드마크 좌표 가져오기
    final leftEye = face.landmarks[FaceLandmarkType.leftEye]?.position;
    final rightEye = face.landmarks[FaceLandmarkType.rightEye]?.position;
    final nose = face.landmarks[FaceLandmarkType.noseBase]?.position;
    final mouthLeft = face.landmarks[FaceLandmarkType.leftMouth]?.position;
    final mouthRight = face.landmarks[FaceLandmarkType.rightMouth]?.position;
    final mouthBottom = face.landmarks[FaceLandmarkType.bottomMouth]?.position; 
    final cheekLeft = face.landmarks[FaceLandmarkType.leftCheek]?.position;
    final cheekRight = face.landmarks[FaceLandmarkType.rightCheek]?.position;

     // 영역별 bounding box 설정
    final Map<String, dynamic> areaBoundingBoxes = {
      "0": {
        "area": "full_face",
        "boundingBox": boundingBoxToJson(boundingBox)
      },
      "1": {
        "area": "forehead",
        "boundingBox": calculateForeheadBox(leftEye as FaceLandmark?, rightEye as FaceLandmark?, boundingBox)
      },
      "2": {
        "area": "glabellus",
        "boundingBox": calculateGlabellusBox(leftEye as FaceLandmark?, rightEye as FaceLandmark?, boundingBox)
      },
      "3": {
        "area": "l_perocular",
        "boundingBox": leftEye != null ? landmarkToBoundingBox(leftEye as FaceLandmark?) : null
      },
      "4": {
        "area": "r_perocular",
        "boundingBox": rightEye != null ? landmarkToBoundingBox(rightEye as FaceLandmark?) : null
      },
      "5": {
        "area": "l_cheek",
        "boundingBox": cheekLeft != null ? landmarkToBoundingBox(cheekLeft as FaceLandmark?) : null
      },
      "6": {
        "area": "r_cheek",
        "boundingBox": cheekRight != null ? landmarkToBoundingBox(cheekRight as FaceLandmark?) : null
      },
      "7": {
        "area": "lip",
        "boundingBox": calculateLipBox(mouthLeft as FaceLandmark?, mouthRight as FaceLandmark?, mouthBottom as FaceLandmark?)
      },
      "8": {
        "area": "chin",
        "boundingBox": calculateChinBox(mouthBottom as FaceLandmark?, boundingBox)
      },
      "9": {
        "area": "nose",
        "boundingBox": nose != null ? landmarkToBoundingBox(nose as FaceLandmark?) : null
      },
    };

    // 각 bounding box 정보 JOSN 으로 전송..?
    return {
      'boundingBoxes': areaBoundingBoxes,
      'eulerAngles': {
        'x': face.headEulerAngleX, // 위로 
        'y': face.headEulerAngleY, // 양의 오일러 Y각이 있는 얼굴은 카메라의 오른쪽을 바라보고, 음수인 경우 왼쪽을 보고 있습니다. 라네요
        'z': face.headEulerAngleZ, // 그 반대 
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

Map<String, dynamic>? landmarkToBoundingBox(FaceLandmark? landmark) {
  if (landmark == null) return null;
  return {
    'x': landmark.position.x,
    'y': landmark.position.y,
  };
}

//이마
Map<String, dynamic> calculateForeheadBox(FaceLandmark? leftEye, FaceLandmark? rightEye, Rect faceBox) {
  if (leftEye == null || rightEye == null) {
    return {}; // 랜드마크가 null이면 빈 맵 반환
  }
  final eyeCenterY = (leftEye.position.y + rightEye.position.y) / 2;
  return {
    'left': faceBox.left,
    'top': faceBox.top,
    'right': faceBox.right,
    'bottom': eyeCenterY - (faceBox.height * 0.05), // 눈 중심보다 약간 위까지 이마로 설정
  };
}


//미간
Map<String, dynamic> calculateGlabellusBox(FaceLandmark? leftEye, FaceLandmark? rightEye, Rect faceBox) {
  if (leftEye == null || rightEye == null) {
    return {}; // 랜드마크가 null이면 빈 맵 반환
  }
  final centerX = (leftEye.position.x + rightEye.position.x) / 2;
  final centerY = (leftEye.position.y + rightEye.position.y) / 2;
  final boxWidth = (rightEye.position.x - leftEye.position.x) * 0.5;

  return {
    'left': centerX - boxWidth / 2,
    'top': centerY - boxWidth / 2,
    'right': centerX + boxWidth / 2,
    'bottom': centerY + boxWidth / 2,
  };
}

//입술영역
Map<String, dynamic> calculateLipBox(FaceLandmark? mouthLeft, FaceLandmark? mouthRight, FaceLandmark? mouthBottom) {
  if (mouthLeft == null || mouthRight == null || mouthBottom == null) {
    return {}; // 랜드마크가 null이면 빈 맵 반환
  }

  return {
    'left': mouthLeft.position.x,
    'top': mouthLeft.position.y,
    'right': mouthRight.position.x,
    'bottom': mouthBottom.position.y,
  };
}

//턱
Map<String, dynamic> calculateChinBox(FaceLandmark? mouthBottom, Rect faceBox) {
  if (mouthBottom == null) {
    return {}; // 랜드마크가 null이면 빈 맵 반환
  }
  return {
    'left': faceBox.left,
    'top': mouthBottom.position.y,
    'right': faceBox.right,
    'bottom': faceBox.bottom,
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
                      // 버튼 동작 추가
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      elevation: 10, // 버튼 그림자 깊이
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

    // 얼굴 정보를 백엔드로 전송
    await sendFaceDataToServer(faces); // 얼굴 데이터를 서버로 전송
    
    // 바운딩 박스 정보 콘솔에 출력하는 부분 ******************************************************************************
    for (var face in faces) {
      final boundingBox = face.boundingBox;
      print('Full face bounding box: ${boundingBoxToJson(boundingBox)}');

    // 각 얼굴 영역의 바운딩 박스 계산 후 출력
    final leftEye = face.landmarks[FaceLandmarkType.leftEye]?.position;
    final rightEye = face.landmarks[FaceLandmarkType.rightEye]?.position;
    final nose = face.landmarks[FaceLandmarkType.noseBase]?.position;
    final mouthLeft = face.landmarks[FaceLandmarkType.leftMouth]?.position;
    final mouthRight = face.landmarks[FaceLandmarkType.rightMouth]?.position;
    final mouthBottom = face.landmarks[FaceLandmarkType.bottomMouth]?.position;
    final cheekLeft = face.landmarks[FaceLandmarkType.leftCheek]?.position;
    final cheekRight = face.landmarks[FaceLandmarkType.rightCheek]?.position;

    final foreheadBox = calculateForeheadBox(leftEye as FaceLandmark?, rightEye as FaceLandmark?, boundingBox);
    final glabellusBox = calculateGlabellusBox(leftEye as FaceLandmark?, rightEye as FaceLandmark?, boundingBox);
    final lipBox = calculateLipBox(mouthLeft as FaceLandmark?, mouthRight as FaceLandmark?, mouthBottom as FaceLandmark?);
    final chinBox = calculateChinBox(mouthBottom as FaceLandmark?, boundingBox);

    print('Forehead bounding box: $foreheadBox');
    print('Glabellus bounding box: $glabellusBox');
    print('Lip bounding box: $lipBox');
    print('Chin bounding box: $chinBox');

    if (leftEye != null) {
      print('Left eye bounding box: ${landmarkToBoundingBox(leftEye as FaceLandmark?)}');
    }
    if (rightEye != null) {
      print('Right eye bounding box: ${landmarkToBoundingBox(rightEye as FaceLandmark?)}');
    }
    if (cheekLeft != null) {
      print('Left cheek bounding box: ${landmarkToBoundingBox(cheekLeft as FaceLandmark?)}');
    }
    if (cheekRight != null) {
      print('Right cheek bounding box: ${landmarkToBoundingBox(cheekRight as FaceLandmark?)}');
    }
    if (nose != null) {
      print('Nose bounding box: ${landmarkToBoundingBox(nose as FaceLandmark?)}');
    }
  }
  // 출력 부분 여기까지 지우면 됨  *************************************************************************************

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
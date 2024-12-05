import 'dart:ui';

import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

Map<String, Rect> extractFaceRegionsWithLandmarks(Face face) {
  final landmarks = face.landmarks;

  // 필요한 랜드마크 가져오기
  final leftEye = landmarks[FaceLandmarkType.leftEye]?.position;
  final rightEye = landmarks[FaceLandmarkType.rightEye]?.position;
  final nose = landmarks[FaceLandmarkType.noseBase]?.position;
  final leftMouth = landmarks[FaceLandmarkType.leftMouth]?.position;
  final rightMouth = landmarks[FaceLandmarkType.rightMouth]?.position;

  if (leftEye == null || rightEye == null || nose == null || leftMouth == null || rightMouth == null) {
    throw Exception('얼굴이 인식되지 않았습니다. 얼굴이 보이도록 사진을 찍어주세요.');
  }

  // 얼굴 전체 바운딩 박스
  final boundingBox = face.boundingBox;

  return {
    'full_face': Rect.fromLTRB(
      boundingBox.left.toDouble(),
      boundingBox.top.toDouble(),
      boundingBox.right.toDouble(),
      boundingBox.bottom.toDouble(),
    ),
    'forehead': Rect.fromLTRB(
      boundingBox.left.toDouble(),
      boundingBox.top.toDouble(),
      boundingBox.right.toDouble(),
      nose.y.toDouble(),
    ),
    'glabellus': Rect.fromLTRB(
      leftEye.x.toDouble(),
      leftEye.y.toDouble(),
      rightEye.x.toDouble(),
      nose.y.toDouble(),
    ),
    'l_perocular': Rect.fromLTRB(
      boundingBox.left.toDouble(),
      boundingBox.top.toDouble(),
      leftEye.x.toDouble(),
      leftEye.y.toDouble(),
    ),
    'r_perocular': Rect.fromLTRB(
      rightEye.x.toDouble(),
      boundingBox.top.toDouble(),
      boundingBox.right.toDouble(),
      rightEye.y.toDouble(),
    ),
    'l_cheek': Rect.fromLTRB(
      boundingBox.left.toDouble(),
      leftEye.y.toDouble(),
      nose.x.toDouble(),
      leftMouth.y.toDouble(),
    ),
    'r_cheek': Rect.fromLTRB(
      nose.x.toDouble(),
      rightEye.y.toDouble(),
      boundingBox.right.toDouble(),
      rightMouth.y.toDouble(),
    ),
    'lip': Rect.fromLTRB(
      leftMouth.x.toDouble(),
      leftMouth.y.toDouble(),
      rightMouth.x.toDouble(),
      boundingBox.bottom.toDouble(),
    ),
    'chin': Rect.fromLTRB(
      boundingBox.left.toDouble(),
      rightMouth.y.toDouble(),
      boundingBox.right.toDouble(),
      boundingBox.bottom.toDouble(),
    ),
  };
}

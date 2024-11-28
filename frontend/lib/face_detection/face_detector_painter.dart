import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (final Face face in faces) {
      if (face.headEulerAngleY != null) {
        if (face.headEulerAngleY! > 10) {
          // 완쪽으로 고개를 돌린 경우 파란색
          paint.color = Colors.blue;
        } else if (face.headEulerAngleY! < -10) {
          // 오른쪽으로 고개를 돌린 경우 빨간색
          paint.color = Colors.red;
        } else {
          // 정면을 바라볼 경우 흰색
          paint.color = Colors.white;
        }
      } 

      // 얼굴 바운딩 박스를 이미지 크기에 맞춰 변환
      final Rect boundingBox = Rect.fromLTRB(
        translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
        translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
        translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
        translateY(face.boundingBox.bottom, rotation, size, absoluteImageSize),
      );

      // 바운딩 박스 그리기
      canvas.drawRect(boundingBox, paint);
    }
  }

  // X 좌표 변환
  double translateX(double x, InputImageRotation rotation, Size size, Size absoluteImageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x * size.width / absoluteImageSize.height;
      case InputImageRotation.rotation270deg:
        return size.width - x * size.width / absoluteImageSize.height;
      default:
        return x * size.width / absoluteImageSize.width;
    }
  }

  // Y 좌표 변환
  double translateY(double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * size.height / absoluteImageSize.width;
      default:
        return y * size.height / absoluteImageSize.height;
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}

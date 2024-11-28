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

    for (final Face face in faces) {// face_detecttor_page에 정의해놈 Euler Y 각도에 따라 색상 결정
      if (face.headEulerAngleY != null) {
        if (face.headEulerAngleY! < 0) {// 얼굴이 왼쪽으로 기울어지면 빨간색 -> 근데 좌우반전시켜서 우리한텐 반대임
          paint.color = Colors.red;
        } else { // 얼굴이 오른쪽으로 기울어진 경우 파란색 -> 위와 같은 경우로 우리한텐 반대
          paint.color = Colors.blue;
        }
      } else {
        // Euler Y 각도가 없는 경우 기본 색상 -> 인데 각도가 없기가 힘듬
        paint.color = Colors.green;
      }
      // 얼굴 바운딩 박스를 이미지 크기에 맞춰 변환
      final Rect boundingBox = Rect.fromLTRB(
        translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
        translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
        translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
        translateY(face.boundingBox.bottom, rotation, size, absoluteImageSize),
      );
      //바운딩 박스 그리기용
      canvas.drawRect(boundingBox, paint);
    }
  }

  //변환
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
//좌표변환
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

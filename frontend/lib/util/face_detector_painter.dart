import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final InputImageRotation rotation;

  FaceDetectorPainter(this.faces, this.imageSize, this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    for (final face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.left, rotation, size, imageSize),
          translateY(face.boundingBox.top, rotation, size, imageSize),
          translateX(face.boundingBox.right, rotation, size, imageSize),
          translateY(face.boundingBox.bottom, rotation, size, imageSize),
        ),
        paint,
      );
    }
  }

  double translateX(double x, InputImageRotation rotation, Size size, Size absoluteSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return size.width - x * size.width / absoluteSize.height;
      case InputImageRotation.rotation270deg:
        return x * size.width / absoluteSize.height;
      default:
        return x * size.width / absoluteSize.width;
    }
  }

  double translateY(double y, InputImageRotation rotation, Size size, Size absoluteSize) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * size.height / absoluteSize.width;
      default:
        return y * size.height / absoluteSize.height;
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}

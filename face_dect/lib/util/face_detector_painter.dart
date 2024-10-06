import 'dart:math';

import 'package:flutter/material.dart'; 
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'courdinates_painter.dart';


class FaceDetectorPainter extends CustomPainter{

  final List<Face>faces;
  final Size absoluteIamgeSize;
  final InputImageRotation;
  final rotation;

  FaceDetectorPainter(this.faces, this.absoluteIamgeSize, this.rotation, this.InputImageRotation);

  @override
  void paint(final Canvas canvas, final Size size){
    final Paint paint=Paint()
    ..style=PaintingStyle.stroke
    ..strokeWidth=1.0
    ..color=Colors.blue;
    for(final Face face in faces){
      canvas.drawRect(
        Rect.fromLTRB(
        translateX(face.boundingBox.left, rotation, size, absoluteIamgeSize), 
        translateY(face.boundingBox.top, rotation, size, absoluteIamgeSize),
        translateX(face.boundingBox.right, rotation, size, absoluteIamgeSize),
        translateY(face.boundingBox.bottom, rotation, size, absoluteIamgeSize),
        ),paint,
      );
      //얼굴 주변에 파란색 그리기
      void paintContour(final FaceContourType type){
        final faceContour=face.contours[type];
        if(faceContour?.points!=null){
          for(final Point point in faceContour!.points){
            canvas.drawCircle(Offset(translateX(
              point.x.toDouble(), rotation, size, absoluteIamgeSize),
              translateY(
                point.y.toDouble(), rotation, size, absoluteIamgeSize)
            ),1.0,paint);
          }
        }
      }
      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEyebrowTop);
      paintContour(FaceContourType.leftEyebrowBottom);
      paintContour(FaceContourType.rightEyebrowTop);
      paintContour(FaceContourType.rightEyebrowBottom);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.noseBottom);
      paintContour(FaceContourType.noseBridge);
      paintContour(FaceContourType.leftCheek);
      paintContour(FaceContourType.rightCheek);




    }
  }

  @override 
  bool shouldRepaint(final FaceDetectorPainter oldDelegate){
    return oldDelegate.absoluteIamgeSize!=absoluteIamgeSize||
    oldDelegate.faces != faces;
    
  }

  

}
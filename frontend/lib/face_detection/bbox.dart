// 바운딩 박스 값 따기
import 'dart:ui';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

Map<String, Rect> extractFaceRegions(Face face) {
  final boundingBox = face.boundingBox;
/*
area_names = {
        "0": "full_face",
        "1": "forehead",
        "2": "glabellus",
        "3": "l_perocular",
        "4": "r_perocular",
        "5": "l_cheek",
        "6": "r_cheek",
        "7": "lip",
        "8": "chin"
*/
  return {
    //얼굴 전체
    'full_face':Rect.fromLTRB( 
      boundingBox.left, 
      boundingBox.top, 
      boundingBox.right, 
      boundingBox.left
      ),
    //이마
    'forehead': Rect.fromLTRB(
      boundingBox.left,
      boundingBox.top,
      boundingBox.right,
      boundingBox.top + boundingBox.height * 0.2,
    ),
    //미간
    'glabellus': Rect.fromLTRB(
      boundingBox.left + boundingBox.width * 0.3,
      boundingBox.top + boundingBox.height * 0.2,
      boundingBox.right - boundingBox.width * 0.3,
      boundingBox.top + boundingBox.height * 0.35,
    ),
    // 왼쪽 눈가
    'l_perocular': Rect.fromLTRB(
      boundingBox.left,
      boundingBox.top + boundingBox.height * 0.25,
      boundingBox.left + boundingBox.width * 0.4,
      boundingBox.top + boundingBox.height * 0.4,
    ),
    //오른쪽 눈가
    'r_perocular': Rect.fromLTRB(
      boundingBox.right - boundingBox.width * 0.4,
      boundingBox.top + boundingBox.height * 0.25,
      boundingBox.right,
      boundingBox.top + boundingBox.height * 0.4,
    ),
    //왼쪽 볼
    'l_cheek': Rect.fromLTRB(
      boundingBox.left,
      boundingBox.top + boundingBox.height * 0.4,
      boundingBox.left + boundingBox.width * 0.4,
      boundingBox.bottom - boundingBox.height * 0.2,
    ),
    //오른쪽 볼
    'r_cheek': Rect.fromLTRB(
      boundingBox.right - boundingBox.width * 0.4,
      boundingBox.top + boundingBox.height * 0.4,
      boundingBox.right,
      boundingBox.bottom - boundingBox.height * 0.2,
    ),
    //입술
    'lip': Rect.fromLTRB(
      boundingBox.left + boundingBox.width * 0.3,
      boundingBox.bottom - boundingBox.height * 0.25,
      boundingBox.right - boundingBox.width * 0.3,
      boundingBox.bottom - boundingBox.height * 0.15,
    ),
    //턱
    'chin': Rect.fromLTRB(
      boundingBox.left + boundingBox.width * 0.2,
      boundingBox.bottom - boundingBox.height * 0.2,
      boundingBox.right - boundingBox.width * 0.2,
      boundingBox.bottom,
    ),
  };
}

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frontend/face_detection/face_result.dart';
import 'package:http/http.dart' as http;

Future<void> sendFaceDataToServer( String areaName, Rect boundingBox, File imageFile, BuildContext context) async {
  final url = 'http://3.34.5.57/predict/$areaName';

  // bbox 데이터를 쉼표로 구분된 문자열로 변환하고
  final bboxString = boundingBoxToString(boundingBox);

  try {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['bbox'] = bboxString // 쉼표로 구분된 문자열로 전송
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // 디버깅 로그 출력용
    print('요청할 URL: $url');
    print('요청할 bbox: $bboxString');
    print('요청할 file: ${imageFile.path}');

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {

      print('####### 얼굴 사진 전송됨');
      print('####### 응답 body: $responseBody');

      // 성공 시 BSTI 화면으로 이동
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const BSTI(),
        ),
      );
      


    } else {
      print('####### 전송 실패 : ${response.statusCode}');
      print('####### 응답 body: $responseBody');
    }
  } catch (e) {
    print('#######에러뜸: $e');
  }
}

String boundingBoxToString(Rect boundingBox) {
  // 음수 값 처리: 음수 좌표는 0으로 보정 (임시로)
  return [
    boundingBox.left.toInt() < 0 ? 0 : boundingBox.left.toInt(),
    boundingBox.top.toInt() < 0 ? 0 : boundingBox.top.toInt(),
    boundingBox.right.toInt() < 0 ? 0 : boundingBox.right.toInt(),
    boundingBox.bottom.toInt() < 0 ? 0 : boundingBox.bottom.toInt()
  ].join(','); // 쉼표로 구분된 문자열 생성
}

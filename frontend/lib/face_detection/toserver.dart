import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/server_config.dart';
import 'package:frontend/face_detection/face_result.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/Constants/user_data.dart'; // UserData import

Future<void> sendFaceDataToServer(String areaName, Rect boundingBox,
    File imageFile, BuildContext context, UserData userData) async {
  // UserData 추가
  final url = '${ServerConfig.baseUrl}/predict/$areaName';

  // bbox 데이터를 쉼표로 구분된 문자열로 변환
  final bboxString = boundingBoxToString(boundingBox);

  try {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['bbox'] = bboxString
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // 디버깅 로그 출력
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
        context,
        MaterialPageRoute(
          builder: (context) => BSTI(userData),
        ),
      );
    } else {
      print('####### 전송 실패 : ${response.statusCode}');
      print('####### 응답 body: $responseBody');
    }
  } catch (e) {
    print('####### 에러 발생: $e');
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

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;

Future<void> sendFaceDataToServer(String areaName, Rect boundingBox, File imageFile) async {
  final url = 'http://3.34.5.57/predict/$areaName';

  // bbox 데이터를 쉼표로 구분된 문자열로 변환하고
  final bboxString = boundingBoxToString(boundingBox);

  try {
    final request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['bbox'] = bboxString // 쉼표로 구분된 문자열로 전송
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // 디버깅 로그 출력용
    print('Request URL: $url');
    print('Request bbox: $bboxString');
    print('Request file: ${imageFile.path}');

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Face data sent successfully');
    } else {
      print('Failed to send face data: ${response.statusCode}');
      print('Response body: $responseBody');
    }
  } catch (e) {
    print('Error sending face data: $e');
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

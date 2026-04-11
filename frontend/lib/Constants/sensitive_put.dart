import 'dart:convert'; // JSON 변환에 사용
import 'package:frontend/Constants/server_config.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:http/http.dart' as http; // HTTP 요청에 사용

Future<void> updateSensitiveSkinStatus(
    bool hasSensitiveSkin, UserData userData) async {
  final url =
      Uri.parse('${ServerConfig.usersUrl}/${userData.id}'); // 백엔드 주소를 넣어주세요
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'has_sensitive_skin': hasSensitiveSkin});

  try {
    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );

    switch (response.statusCode) {
      case 200:
        print('성공적으로 업데이트되었습니다.');
        userData.sensitive = hasSensitiveSkin;
        break;
      case 404:
        print('sensitive 백엔드 엔드포인트를 찾을 수 없습니다.');
        break;
      case 402:
        print('유효성 검사 오류입니다. 입력 값을 확인하세요.');
        break;
      default:
        print('오류 발생: ${response.statusCode}, ${response.body}');
    }
  } catch (e) {
    print('요청 중 오류가 발생했습니다: $e');
  }
}

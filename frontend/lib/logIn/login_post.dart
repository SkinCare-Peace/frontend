import 'dart:convert';
import 'package:frontend/Constants/user_data.dart';
import 'package:http/http.dart' as http;

Future<UserData?> fetchUserData(String email) async {
  final url = Uri.parse('http://3.34.5.57/users/email/{$email}'); // 실제 엔드포인트로 변경
  final headers = {'Content-Type': 'application/json'}; // 요청 헤더 설정

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // 성공 시 JSON 데이터를 파싱하여 UserData 객체 반환
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return UserData.fromJson(responseData);
    } else {
      // 에러 처리
      print("Error: Status code ${response.statusCode}");
      return null;
    }
  } catch (e) {
    // 예외 처리
    print("Error: $e");
    return null;
  }
}

import 'dart:convert'; // JSON 변환을 위해 필요
import 'package:http/http.dart' as http; // HTTP 요청을 위해 필요

Future<void> userRegister(String name, String email, String password) async {
  final url = Uri.parse('http://3.34.5.57/users/'); // 백엔드의 엔드포인트
  final headers = {'Content-Type': 'application/json'}; // 요청 헤더 설정
  final body = jsonEncode({
    "email": email,
    "name": name,
    "password": password,
  }); // 요청 body 생성

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      // 성공 (201 Created)
      final responseData = jsonDecode(response.body);
      print("User registered successfully!");
      print("Response Data: $responseData");
    } else if (response.statusCode == 404) {
      // 404 Not Found
      print("Error: Endpoint not found.");
    } else if (response.statusCode == 422) {
      // 422 Validation Error
      print("Error: Validation failed. Please check the input data.");
    } else {
      // 기타 에러
      print("Error: Unexpected status code ${response.statusCode}");
    }
  } catch (e) {
    // 예외 처리
    print("Error: $e");
  }
}

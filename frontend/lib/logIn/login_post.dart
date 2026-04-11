import 'dart:convert';
import 'package:frontend/Constants/null_parsing.dart';
import 'package:frontend/Constants/server_config.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:http/http.dart' as http;

Future<UserData?> fetchUserData(String email) async {
  final url = Uri.parse('${ServerConfig.usersUrl}/email/$email'); // 실제 엔드포인트로 변경

  try {
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final parsedData = replaceNullWithEmptyString(responseData);
      print("로그인 정보는~");
      print(parsedData);
      return UserData.fromJson(parsedData);
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

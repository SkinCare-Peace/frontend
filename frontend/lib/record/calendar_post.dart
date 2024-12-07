import 'dart:convert';
import 'package:frontend/Constants/user_data.dart';
import 'package:http/http.dart' as http;

// user_id를 받아 해당 사용자의 routine 데이터를 가져와서 List<DateTime> 반환하는 함수
Future<List<DateTime>> fetchMarkedDates(UserData userData) async {
  final url = Uri.parse("http://3.34.5.57/routine/${userData.id}");

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // 응답 데이터 파싱
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      // dates 배열 추출
      final List<dynamic> dateStrings = data['dates'] ?? [];

      // 문자열 리스트를 DateTime 리스트로 변환
      List<DateTime> dates = dateStrings.map((dateStr) {
        return DateTime.parse(dateStr);
      }).toList();

      print("성공 날짜 $dates");

      return dates;
    } else if (response.statusCode == 404) {
      // Not Found 처리: 여기서는 단순히 빈 리스트 반환
      // 필요하면 Exception을 던지거나 다른 처리 가능
      print("Not Found");
      return [];
    } else if (response.statusCode == 422) {
      // Validation Error 처리: 여기서도 단순히 빈 리스트 반환
      // 필요하면 Exception을 던지거나 다른 처리 가능
      print("Validation Error: user_id=${userData.id}");
      return [];
    } else {
      // 기타 예상치 못한 응답 코드 처리
      print("Unexpected status code: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    // 네트워크 오류, JSON 파싱 오류 등 처리
    print("Error fetching routine data for user_id=${userData.id}: $e");
    return [];
  }
}

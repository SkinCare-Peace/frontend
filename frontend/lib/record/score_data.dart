import 'dart:convert';
import 'package:http/http.dart' as http;

final dashScore = DashScore();
class DashScore {
  final Map<String, int> _dashScoreData = {};
  // 데이터 저장
  void saveData(String areaName, int score) {
    _dashScoreData[areaName] = score;
    print('####### $areaName dash데이터 저장 성공: $score');
  }

    // 데이터를 서버로 POST 요청
  Future<String> postData(String userId) async {
    // 필요한 key만 필터링
    final List<String> allowedKeys = [
      'acne',
      'dryness',
      'pigmentation',
      'wrinkle',
      'pore',
      'elasticity'
    ];
    final Map<String, int> filteredScores = Map.fromEntries(
      _dashScoreData.entries.where((entry) => allowedKeys.contains(entry.key)),
    );

    // 현재 날짜 가져오기
    final String currentDate = DateTime.now().toIso8601String().split('T').first;

    // 요청 데이터 생성
    final Map<String, dynamic> requestData = {
      'user_id': userId,
      'date': currentDate,
      'scores': filteredScores,
    };

    // HTTP POST 요청
    try {
      final response = await http.post(
        Uri.parse('http://3.34.5.57/statistics/'), // 여기에 API URL 입력
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      // 응답 처리
      if (response.statusCode == 201) {
        print('POST 요청 성공: ${response.body}');
        return response.body;
      } else if (response.statusCode == 404) {
        print('에러: Not Found (404)');
        return 'Not Found (404)';
      } else if (response.statusCode == 422) {
        print('에러: Validation Error (422)');
        return 'Validation Error (422)';
      } else {
        print('알 수 없는 에러: ${response.statusCode}');
        return 'Unknown Error (${response.statusCode})';
      }
    } catch (e) {
      print('POST 요청 중 에러 발생: $e');
      return 'Request Error';
    }
  }
}
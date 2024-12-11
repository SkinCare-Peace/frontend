// Regression 데이터를 저장하고 반환하기 위한 클래스
import 'dart:convert';

class AcneDataStore {
  final Map<String, int> _acneData = {};
  // 데이터 저장
  void saveData(String areaName, int score) {
    _acneData[areaName] = score;
    print('####### $areaName acne 데이터 저장 성공: $score');
  }

    // 가장 작은 값을 반환하는 메서드
  int? getMinScore() {
    if (_acneData.isEmpty) {
      return null; // 데이터가 없으면 null 반환
    }
    return _acneData.values.reduce((min, score) => score < min ? score : min);
  }

}

final acneDataStore = AcneDataStore();
// 여드름 서버 응답 처리 및 regression 데이터 저장
Future<void> processServerResponse_acne(
    String regionName, String responseBody) async {
  try {
    // JSON 파싱
    final responseJson = jsonDecode(responseBody);

    // processed_image와 score 확인
    if (responseJson.containsKey('processed_image') &&
        responseJson.containsKey('score')) {
      final processedImage = responseJson['processed_image'];
      final score = responseJson['score'];

      print('Processed Image: $processedImage');
      print('$regionName acne Score: $score');
      acneDataStore.saveData(regionName, score);
    } else {
      print('####### 여드름 응답에 필수 데이터가 없습니다.');
    }
  } catch (e) {
    print('####### 여드름 응답 처리 중 오류 발생: $e');
  }
}

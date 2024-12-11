// Regression 데이터를 저장하고 반환하기 위한 클래스
import 'dart:convert';

class RegressionDataStore {
  final Map<String, Map<String, double>> _regressionData = {};

  // 항목별로 데이터를 저장
  final Map<String, Map<String, double>> _categoryBasedData = {};

  // 데이터 저장
  void saveData(String areaName, Map<String, double> regressionValues) {
    _regressionData[areaName] = regressionValues;
    print('####### $areaName regression 데이터 저장 성공: $regressionValues');
    // 항목별로 데이터 저장
    for (var entry in regressionValues.entries) {
      final category = entry.key;
      final value = entry.value;
      if (!_categoryBasedData.containsKey(category)) {
        _categoryBasedData[category] = {};
      }
      _categoryBasedData[category]![areaName] = value;
    }
  }

  // 특정 영역 데이터 반환
  Map<String, double>? getData(String areaName) {
    return _regressionData[areaName];
  }

  // 모든 데이터 반환
  Map<String, Map<String, double>> getAllData() {
    return _regressionData;
  }

  // 항목별 데이터 반환
  Map<String, Map<String, double>> getCategoryBasedData() {
    return _categoryBasedData;
  }

  // 평균 및 특정 조건 적용하여 데이터 반환
  Map<String, double> processAndAggregateData(
      Map<String, double> scalingFactors) {
    final result = <String, double>{};
    // moisture, elasticity, wrinkle 평균 계산
    for (var category in ["moisture", "elasticity", "wrinkle"]) {
      if (_categoryBasedData.containsKey(category)) {
        final values = _categoryBasedData[category]!.values;
        if (values.isNotEmpty) {
          final average = values.reduce((a, b) => a + b) / values.length;
          result[category] = average * (scalingFactors[category] ?? 1.0);
        }
      }
    }
    // pigmentation 그대로 사용
    if (_categoryBasedData.containsKey("pigmentation")) {
      final pigmentationValue =
          _categoryBasedData["pigmentation"]?.values.first;
      if (pigmentationValue != null) {
        result["pigmentation"] =
            pigmentationValue * (scalingFactors["pigmentation"] ?? 1.0);
      }
    }
    // pore에서 최대값 선택
    if (_categoryBasedData.containsKey("pore")) {
      final values = _categoryBasedData["pore"]!.values;
      if (values.isNotEmpty) {
        final maxPore = values.reduce((a, b) => a > b ? a : b);
        result["pore"] = maxPore * (scalingFactors["pore"] ?? 1.0);
      }
    }
    return result;
  }

  // 데이터 가공 및 변환 함수 추가
  Map<String, double> aggregateData(
      Map<String, Map<String, double>> inputData) {
    final result = <String, double>{};
    // moisture, elasticity, wrinkle 평균 계산
    for (var category in ["moisture", "elasticity", "wrinkle"]) {
      if (inputData.containsKey(category)) {
        final values = inputData[category]!.values;
        if (values.isNotEmpty) {
          result[category] = values.reduce((a, b) => a + b) / values.length;
        }
      }
    }
    // pore에서 최대값 선택
    if (inputData.containsKey("pore")) {
      final values = inputData["pore"]!.values;
      if (values.isNotEmpty) {
        result["pore"] = values.reduce((a, b) => a > b ? a : b);
      }
    }
    return result;
  }
}

// RegressionDataStore 인스턴스 생성
final regressionDataStore = RegressionDataStore();
// 서버 응답 처리 및 regression 데이터 저장
Future<void> processServerResponse(String areaName, String responseBody) async {
  try {
    // JSON 파싱
    final responseJson = jsonDecode(responseBody);

    // regression_values 추출
    if (responseJson.containsKey('regression_values')) {
      final regressionValues = Map<String, double>.from(
          responseJson['regression_values'] as Map<String, dynamic>);

      // 데이터 저장
      regressionDataStore.saveData(areaName, regressionValues);
    } else {
      print('####### $areaName 응답에 regression_values가 없습니다.');
    }
  } catch (e) {
    print('####### $areaName 응답 처리 중 오류 발생: $e');
  }
}

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
    } else {
      print('####### 여드름 응답에 필수 데이터가 없습니다.');
    }
  } catch (e) {
    print('####### 여드름 응답 처리 중 오류 발생: $e');
  }
}

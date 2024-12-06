Map<String, double> scalingFactors = {
  "elasticity": 1.0,        // 0 ~ 1
  "moisture": 100.0,        // 0 ~ 100
  "wrinkle": 50.0,          // 0 ~ 50
  "pigmentation": 350.0,    // 0 ~ 350
  "pore": 2600.0,           // 0 ~ 2600
};


// 백엔드 응답 데이터 정규화해서 0~100 점수로 변환하는 로직
Map<String, int> normalizeResponse(Map<String, double> responseValues) {
  Map<String, int> normalizedData = {};
  
  responseValues.forEach((key, value) {
    if (scalingFactors.containsKey(key)) {
      // 정규화: (실제 값 / 최대 값) * 100
      int normalizedValue = (value / scalingFactors[key]! * 100).toInt();
      
      // 특정 항목은 점수가 낮을수록 좋음 (100에서 뺌)
      if (key == "pigmentation" || key == "pore" || key == "elasticity") {
        normalizedData[key] = 100 - normalizedValue; // 모공,주름, 색소침착점수는 역점수
      } else {
        normalizedData[key] = normalizedValue; // 일반 점수 계산
      }
    } else {
      normalizedData[key] = value.toInt(); // 스케일링 필요 없는 경우
    }
  });
  
  return normalizedData;
}

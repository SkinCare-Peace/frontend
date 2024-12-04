// 재귀적으로 null 값을 ""로 변환하는 함수
dynamic replaceNullWithEmptyString(dynamic data) {
  if (data is Map<String, dynamic>) {
    // Map인 경우 각 키-값에 대해 검사
    return data.map((key, value) => MapEntry(key, replaceNullWithEmptyString(value)));
  } else if (data is List) {
    // List인 경우 각 요소에 대해 검사
    return data.map((item) => replaceNullWithEmptyString(item)).toList();
  } else if (data == null) {
    // null 값을 빈 문자열로 변환
    return "";
  }
  // 다른 데이터 타입은 그대로 반환
  return data;
}


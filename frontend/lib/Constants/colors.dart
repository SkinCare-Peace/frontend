import 'package:flutter/material.dart';

class AppColors {
  // 기본 색상
  static const Color mainColor = Color(0xFF43C1CD);
  static const Color greyBox = Color.fromARGB(255, 245, 245, 245);

  // 텍스트 색상
  static const Color textBlack = Color(0xFF212121);
  static const Color textWhite = Color.fromARGB(255, 255, 255, 255);

  // 경고 및 상태 색상
  static const Color success = Color(0xFF4CAF50);

  // 점수 상태 색상
  static const Color positiveScore = Color(0xFFDCFCDB); // 긍정적인 점수 (연한 초록색)
  static const Color negativeScore = Color(0xFFFFB8B8); // 부정적인 점수 (연한 빨간색)
  static const Color negative = Color(0xFFFF7778);

  // 기타 색상
  static const Color progressBar = Color(0xFFE0E0E0); // 프로그래스 바 배경색
  static const Color divider = Color(0xFFBDBDBD); // 구분선 색상
}

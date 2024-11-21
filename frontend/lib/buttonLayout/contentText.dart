import 'package:flutter/material.dart';

class ContentText extends StatelessWidget {
  final String text; // 표시할 텍스트
  final double fontSize; // 텍스트 크기

  const ContentText({
    Key? key,
    required this.text,
    this.fontSize = 16, // 기본 글씨 크기
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize, // 텍스트 크기 설정
        fontWeight: FontWeight.w500, // 기본 폰트 굵기
        color: Colors.black, // 텍스트 색상 (필요 시 변경 가능)
      ),
    );
  }
}

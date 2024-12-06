import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';

class TitleText extends StatelessWidget {
  final String text; // 표시할 텍스트

  const TitleText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ContentText_bk extends StatelessWidget {
  final String text; // 표시할 텍스트

  const ContentText_bk({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        color: AppColors.textBlack,
      ),
    );
  }
}

class SubText_grey extends StatelessWidget {
  final String text; // 표시할 텍스트
  final FontWeight fontWeight;

  const SubText_grey({
    super.key,
    required this.text,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        color: AppColors.textgrey,
      ),
    );
  }
}

class SubText_bk extends StatelessWidget {
  final String text; // 표시할 텍스트
  final FontWeight fontweight;
  final int fontSize;

  const SubText_bk({
    super.key,
    required this.text,
    required this.fontweight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textBlack,
      ),
    );
  }
}

class ContentText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const ContentText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}

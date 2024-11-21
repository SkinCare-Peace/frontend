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

class ContentText extends StatelessWidget {
  final String text; // 표시할 텍스트

  const ContentText({
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

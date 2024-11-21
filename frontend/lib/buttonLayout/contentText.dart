import 'package:flutter/material.dart';

class ContentText extends StatelessWidget {
  final String text;
  final double fontSize; 
  final FontWeight fontWeight;

  const ContentText({
    Key? key,
    required this.text,
    this.fontSize = 16, 
    this.fontWeight = FontWeight.w500,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Colors.black, 
      ),
    );
  }
}

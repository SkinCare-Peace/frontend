import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';

class Insight extends StatefulWidget {
  final UserData userData; // UserData 필드 추가
  const Insight(this.userData, {super.key});

  @override
  State<Insight> createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, //배경색 흰색
      body: Column(),
    );
  }
}

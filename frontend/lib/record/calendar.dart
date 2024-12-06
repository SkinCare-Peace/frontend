import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';

class Calander extends StatefulWidget {
  final UserData userData; // UserData 필드 추가
  const Calander(this.userData, {super.key});

  @override
  State<Calander> createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, //배경색 흰색
      body: Column(),
    );
  }
}

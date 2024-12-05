import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/question/question1.dart'; 

class LoadingPage1 extends StatefulWidget {
   final UserData userData; // UserData 필드 추가
  const LoadingPage1(this.userData, {super.key});

  @override
  _LoadingPage1State createState() => _LoadingPage1State();
}



class _LoadingPage1State extends State<LoadingPage1> {
  @override
  void initState() {
    super.initState();
    // 타이머 설정: 3초 후 question1.dart로 이동
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuestionPage1(widget.userData)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "루틴 생성을 위해\n몇 가지 간단한 질문을 할게요!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 60),
            Image.asset(
              'assets/BBI.png', 
              width: 300,
              height: 300,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

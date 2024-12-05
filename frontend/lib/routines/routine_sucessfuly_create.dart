import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/dash.dart';

class RoutineSuccessfullyCreated extends StatelessWidget {
  final UserData userData; // UserData 필드 추가
  const RoutineSuccessfullyCreated(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    // 화면 로드 후 3초 뒤 대시보드로 이동
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (context) => DashPage(userData)),
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '루틴을 저장하는 중이에요!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              '루틴을 매일 꾸준히 기록해보세요!',
              style: TextStyle(
                fontSize: 16, 
                fontWeight:FontWeight.w600,
                color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            Image.asset(
              'assets/BBIcongs.png',
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:frontend/record/dash.dart';

class CompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                '루틴을 완료하셨어요!',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '지금처럼만 한다면 피부가 엄청 좋아질꺼에요!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Image.asset(
              'assets/BBIcongs.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 80),
              // 홈으로 돌아가기 버튼
              ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  '홈으로 돌아가기',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

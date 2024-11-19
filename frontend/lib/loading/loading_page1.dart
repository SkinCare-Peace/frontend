// 로딩 화면 1

import 'package:flutter/material.dart';

class LoadingPage1 extends StatelessWidget {
  const LoadingPage1({Key? key}) : super(key: key);

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
            const SizedBox(height: 100),
            Image.asset(
              'assets/emoji/face1.png', 
              width: 150,
              height: 150,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/question/question1.dart';

class ReCreate extends StatelessWidget {
  final UserData userData; // UserData 필드 추가
  const ReCreate(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return ReCreateHome(userData);
  }
}

class ReCreateHome extends StatelessWidget {
  final UserData userData;
  const ReCreateHome(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  '루틴을 변경하시나요?',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 43, 43, 43),
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/BBIhappy.png',
                  height: 200,
                ),
                const SizedBox(height:100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 207, 207, 207),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                  ),
                  child: const Text(
                    '        다음에요!       ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
           
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              QuestionPage1(userData))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                  ),
                  child: const Text(
                    '루틴을 변경할래요!',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text,
      {required double fontSize,
      required Color color,
      required FontWeight fontWeight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // 줄 간격 조정
      child: Row(
        children: [
          Icon(
            Icons.check,
            color: color,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize, // 글자 크기 조정
              color: color, // 색상 변경
              fontWeight: fontWeight, // 가중치 추가
            ),
          ),
        ],
      ),
    );
  }
}

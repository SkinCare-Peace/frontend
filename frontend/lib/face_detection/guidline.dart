import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/face_detection/face_detector_page.dart';

class PicGuideline extends StatelessWidget {
  final UserData userData; // UserData 필드 추가
  const PicGuideline(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return PicGuidelineHome(userData);
  }
}

class PicGuidelineHome extends StatelessWidget {
  final UserData userData;
  const PicGuidelineHome(this.userData, {super.key});

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
                  '촬영은 이렇게 하세요!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 43, 43, 43),
                  ),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  'assets/BBIloading.png',
                  height: 200,
                ),
                const SizedBox(height: 35),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '   올바른 촬영 TIP',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 83, 83, 83),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTipItem(
                      '얼굴을 가이드에 맞춰주세요!',
                      fontSize: 17,
                      color: const Color.fromARGB(255, 74, 74, 74),
                      fontWeight: FontWeight.w600,
                    ),
                    _buildTipItem(
                      '설명이 나오면 따라주세요!',
                      fontSize: 17,
                      color: const Color.fromARGB(255, 74, 74, 74),
                      fontWeight: FontWeight.w600,
                    ),
                    _buildTipItem(
                      '실내, 밝은 조명에서 찍어주세요!',
                      fontSize: 17,
                      color: const Color.fromARGB(255, 74, 74, 74),
                      fontWeight: FontWeight.w600,
                    ),
                    _buildTipItem(
                      '세수를 마친 후 얼굴 전체가 나오게!',
                      fontSize: 17,
                      color: const Color.fromARGB(255, 74, 74, 74),
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FaceDetectorPage(userData))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                  ),
                  child: const Text(
                    '확인했어요!',
                    style: TextStyle(
                      fontSize: 20,
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

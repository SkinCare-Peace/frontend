import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/buttonLayout/mainButton.dart';
import 'package:frontend/buttonLayout/text.dart';

class DashPage extends StatefulWidget {
  const DashPage({super.key});

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  DateTime selectedDate = DateTime(2024, 8, 20);

  final int criterion = 50;
// 더미 데이터 : 나중에 class 분리 예정.
  final Map<DateTime, Map<String, int>> skinData = {
    DateTime(2024, 8, 20): {
      "수분": 21,
      "모공": 27,
      "여드름": 74,
      "주름": 57,
      "색소침착": 32,
    },
    DateTime(2024, 8, 21): {
      "수분": 25,
      "모공": 30,
      "여드름": 70,
      "주름": 55,
      "색소침착": 28,
    },
    DateTime(2024, 8, 22): {
      "수분": 18,
      "모공": 25,
      "여드름": 20,
      "주름": 60,
      "색소침착": 40,
    },
  };

  void updateDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentData = skinData[selectedDate] ?? {};

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(text: "DSPT 유지민님의\n피부 데이터"),
            const SizedBox(height: 10),
            const ContentText(text: "유지민님의 피부는 어쩌고 저쩌고\n오늘도 화이팅!"),
            const SizedBox(height: 20),

            MainButton(text: "루틴 시작하기", onPressed: () {}),
            const SizedBox(height: 10),
            MainButton(text: "오늘 피부 기록하기", onPressed: () {}),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // 통합 결과
                  },
                  child: const ContentText(text: "통합 결과"),
                ),
                TextButton(
                  onPressed: () {
                    // 결과 통계
                  },
                  child: const ContentText(text: "결과 통계"),
                ),
                TextButton(
                  onPressed: () {
                    // 보유 제품 관리
                  },
                  child: const ContentText(text: "보유 제품 관리"),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // 날짜 변경 버튼과 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => updateDate(-1),
                ),
                Text(
                  "${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => updateDate(1),
                ),
              ],
            ),
            // 데이터 출력
            if (currentData.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.greyBox,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                  children: currentData.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                "${entry.value}점",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 7),
                          LinearProgressIndicator(
                            value: entry.value / 100,
                            color: entry.value >= criterion // 기준 점수에 따른 색상
                                ? AppColors.positiveScore
                                : AppColors.negativeScore,
                            backgroundColor: Colors.white,
                            minHeight: 20,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              )
            else
              const Text("데이터가 없습니다."),
          ],
        ),
      ),
    );
  }
}

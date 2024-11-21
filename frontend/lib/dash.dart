import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/buttonLayout/mainButton.dart';
import 'package:frontend/buttonLayout/contentText.dart'; 

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
      backgroundColor: Colors.white, //배경색 흰색 
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ContentText(
              text: "DSPT 유지민님의\n피부 데이터",
              fontSize: 20,
            ),
            const SizedBox(height: 10),
            const ContentText(
              text: "유지민님의 피부는 어쩌고 저쩌고\n오늘도 화이팅!",
              fontSize: 16,
            ),
            const SizedBox(height: 20),

            MainButton(text: "루틴 시작하기", onPressed: () {}),
            const SizedBox(height: 10),
            MainButton(text: "오늘 피부 기록하기", onPressed: () {}),
            const SizedBox(height: 20),

            // 통합 결과, 결과 통계, 보유 제품 관리 버튼들 ->  하나의 컨테이너로 묶음
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
              color: AppColors.greyBox,
              borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // 통합 결과
                    },
                    child: const ContentText(
                      text: "통합 결과",
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 결과 통계
                    },
                    child: const ContentText(
                      text: "결과 통계",
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 보유 제품 관리
                    },
                    child: const ContentText(
                      text: "보유 제품 관리",
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => updateDate(1),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 데이터 출력
            if (currentData.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.greyBox,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  height: 250, // 스크롤 영역 제한
                  child: SingleChildScrollView(
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
                                  ContentText(
                                    text: entry.key,
                                    fontSize: 13,
                                  ),
                                  const SizedBox(width: 7),
                                  ContentText(
                                    text: "${entry.value}점",
                                    fontSize: 20,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: LinearProgressIndicator(
                                  value: entry.value / 100,
                                  color: entry.value >= criterion
                                      ? AppColors.positiveScore
                                      : AppColors.negativeScore,
                                  backgroundColor: Colors.white,
                                  minHeight: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              )
            else
              const ContentText(
                text: "데이터가 없습니다.",
                fontSize: 16,
              ),
          ],
        ),
      ),
    );
  }
}

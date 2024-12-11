import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/bsti_bbi_image.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/addProduct/added_product.dart';
import 'package:frontend/layout/mainButton.dart';
import 'package:frontend/layout/text.dart';
import 'package:frontend/loading/loading_page0.dart';
import 'package:frontend/record/insight.dart';
import '../routines/routine_start.dart';

class DashPage extends StatefulWidget {
  final UserData userData; // UserData 필드 추가
  const DashPage(this.userData, {super.key});

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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentTextLeft(
                      text: "${widget.userData.bsti} ${utf8.decode(widget.userData.name.runes.toList())}님의\n피부 데이터",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    ContentTextLeft(
                      text: "${utf8.decode(widget.userData.name.runes.toList())}님! 오늘도 화이팅해요!",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                //Image.asset(BBISTI(widget.userData.bsti)),
                Image.asset(
                  BBISTI.bstiBBI(widget.userData.bsti),
                  width: MediaQuery.of(context).size.width*0.3,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
            const SizedBox(height: 20),

            MainButton(
                text: "루틴 시작하기",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoutineStartPage(widget.userData),
                    ),
                  );
                }),
            const SizedBox(height: 10),
            MainButton(
              text: "오늘 피부 기록하기",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoadingPage0(widget.userData),
                    ));
              },
            ),
            const SizedBox(height: 20),

            // 통합 결과, 결과 통계, 보유 제품 관리 버튼들 ->  하나의 컨테이너로 묶음
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.greyBox,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Insight(widget.userData),
                          ));
                    },
                    child: const ContentText(
                      text: "결과 통계",
                      fontSize: 14,
                    ),
                  ),
                  const Text("|", style: TextStyle(fontSize: 25),),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddedProduct(
                              widget.userData,
                            ),
                          ));
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
                Container(
                  // 날짜 표시용 컨테이너
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.greyBox,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
                  padding: const EdgeInsets.only(
                      left: 20, right: 10, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.greyBox,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SizedBox(
                      height: 250, // 스크롤 영역 제한
                      child: Scrollbar(
                        // 스크롤바
                        thumbVisibility: true, // 항상 스크롤바 보이게
                        thickness: 4, // 스크롤바 두께
                        radius: const Radius.circular(10), // 스크롤바 모서리 둥글게
                        child: Padding(
                          // 스크롤바와 내용 사이에 거리 추가
                          padding:
                              const EdgeInsets.only(right: 20), // 오른쪽 간격 추가
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // 왼쪽 정렬
                              children: currentData.entries.map((entry) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                      )))
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

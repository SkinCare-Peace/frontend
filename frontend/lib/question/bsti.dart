import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/buttonLayout/mainButton.dart';
import 'package:frontend/buttonLayout/contentText.dart';
import 'package:frontend/buttonLayout/text.dart';

class BSTI extends StatefulWidget {
  const BSTI({super.key});

  @override
  State<BSTI> createState() => _BSTIState();
}

class _BSTIState extends State<BSTI> {
  DateTime selectedDate = DateTime(2024, 8, 20);

  final int criterion = 50;
// 더미 데이터 : 나중에 class 분리 예정.
  final Map<DateTime, Map<String, int>> skinData = {
    DateTime(2024, 8, 22): {
      "수분": 18,
      "모공": 25,
      "여드름": 20,
      "주름": 60,
      "색소침착": 40,
    },
  };

  final String user_bsti = "OSPT";
  final String bsti_detail = "피부가 반짝 빛나는";
  final String name = "유지민";
  final String describe = "설명";

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
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/img_blue.png'),
            const SizedBox(
              height: 20,
            ),
            SubText_grey(
              text: "$name님은",
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 20),
            SubText_bk(
              text: bsti_detail,
              fontSize: 16,
              fontweight: FontWeight.w400,
            ),
            const SizedBox(height: 10),
            SubText_bk(
              text: user_bsti,
              fontSize: 20,
              fontweight: FontWeight.bold,
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
            ContentText(
              text: describe,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 20),
            MainButton(text: "나만의 루틴 시작하기", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

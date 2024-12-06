import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/scalling.dart';
import 'package:frontend/addProduct/add_main.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/bsti_bbi_image.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/layout/mainButton.dart';
import 'package:frontend/layout/text.dart'; // UserData import
class BSTI extends StatefulWidget {
  final UserData userData; // UserData 전달받음
  const BSTI(this.userData, {super.key});

  @override
  State<BSTI> createState() => _BSTIState();
}

class _BSTIState extends State<BSTI> {
  final int criterion = 50; // 점수 기준
  Map<String, int> skinData = {}; // 정규화된 데이터를 저장할 곳
  final String user_bsti = "DSPT";
  final String bsti_detail = "피부가 반짝 빛나는";


  // 예제 데이터를 정규화해서 UI 업데이트
  void updateSkinDataFromResponse(Map<String, double> responseValues) {
    setState(() {
      skinData = normalizeResponse(responseValues);
    });
  }

  @override
  void initState() {
    super.initState();

    // 테스트용 더미 데이터
    Map<String, double> dummyResponse = {
      "elasticity": 0.55,
      "moisture": 60.0,
      "wrinkle": 20.0,
      "pigmentation": 27.0,
      "pore": 464.0,
    };

    updateSkinDataFromResponse(dummyResponse); // 정규화하고 UI 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                BBISTI.bstiBBI(user_bsti),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15),
              Text(
                "${utf8.decode(widget.userData.name.runes.toList())}님은",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "$bsti_detail,",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(230, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user_bsti,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(230, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ContentText(
                  text: BBISTI.bstiDescription(user_bsti), // BSTI 설명
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 15),
              if (skinData.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: skinData.entries.map((entry) {
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
                                Text(
                                  "${entry.value}점",
                                  style: const TextStyle(
                                    color: Color.fromARGB(179, 0, 0, 0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
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
                                backgroundColor: AppColors.greyBox,
                                minHeight: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
              else
                const ContentText(
                  text: "데이터가 없습니다.",
                  fontSize: 16,
                ),
              const SizedBox(height: 30),
              const Text(
                "결과는 나중에도 볼 수 있어요!",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MainButton(
                  text: "나만의 루틴 시작하기",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddSkinCareMain(widget.userData),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

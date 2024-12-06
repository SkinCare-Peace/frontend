import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/addProduct/add_main.dart';
import 'package:frontend/buttonLayout/mainButton.dart';
import 'package:frontend/buttonLayout/text.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/bsti_bbi_image.dart';
import 'package:frontend/Constants/user_data.dart'; // UserData import

class BSTI extends StatefulWidget {
  final UserData userData; // UserData 전달받음
  const BSTI(this.userData, {super.key});

  @override
  State<BSTI> createState() => _BSTIState();
}

class _BSTIState extends State<BSTI> {
  DateTime selectedDate = DateTime(2024, 8, 22);
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
  final String describe =
      "OSPT는 이러이러한 유형입니다.\n이러이러하니 이러이러하면 좋아요.\n파이팅!\n왜 안 나오지\n뭐지\n제대로 안 나옴 글자가;;";

  @override
  Widget build(BuildContext context) {
    final currentData = skinData[selectedDate] ?? {};

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
                  color: Colors.black54
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "$bsti_detail,",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(230, 0, 0, 0)
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "$user_bsti",
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(230, 0, 0, 0)
                ),
              ),
              const SizedBox(height: 5),
              if (currentData.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                Text(
                                  "${entry.value}점",
                                  style:const TextStyle(
                                    color: Color.fromARGB(179, 0, 0, 0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700
                                  )
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
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ContentText(
                  text: describe,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "결과는 나중에도 볼 수 있어요!",
                style: TextStyle(
                  fontWeight: FontWeight.w600, 
                  color: Colors.grey,
                  fontSize: 12),
                
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

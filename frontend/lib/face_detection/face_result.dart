import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/server_config.dart';
import 'package:frontend/record/dash.dart';
import 'package:http/http.dart' as http;
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
  final int criterion = 60; // 점수 기준
  Map<String, int> skinData = {}; // 정규화된 데이터를 저장할 곳
  late String user_bsti;

  @override
  void initState() {
    super.initState();
    user_bsti = widget.userData.userBSTI();
    print(user_bsti);
    fetchSkinData(widget.userData.id); // 데이터 가져오기
  }

  // GET 요청을 통해 데이터 가져오기
  Future<void> fetchSkinData(String userId) async {
    final uri = Uri.parse('${ServerConfig.statisticsUrl}/${widget.userData.id}');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 데이터 변환
        final Map<String, String> keyTranslation = {
          "acne": "여드름",
          "moisture": "수분",
          "pigmentation": "색소침착",
          "wrinkle": "주름",
          "pore": "모공",
          "elasticity": "탄력",
        };

        // 정규화된 데이터를 저장
        final translatedData =
            (responseData['statistics'] as Map<String, dynamic>)
                .values
                .first
                .map((k, v) => MapEntry(keyTranslation[k] ?? k, v));

        setState(() {
          skinData = Map<String, int>.from(translatedData);
        });

        print('데이터 로드 성공: $translatedData');
      } else if (response.statusCode == 404) {
        print('에러: Not Found (404)');
        _showErrorDialog('데이터를 찾을 수 없습니다.');
      } else if (response.statusCode == 422) {
        print('에러: Validation Error (422)');
        _showErrorDialog('요청이 유효하지 않습니다.');
      } else {
        print('알 수 없는 에러: ${response.statusCode}, ');
        _showErrorDialog('알 수 없는 문제가 발생했습니다.');
      }
    } catch (e) {
      print('GET 요청 중 에러 발생: $e');
      _showErrorDialog('네트워크 오류가 발생했습니다.');
    }
  }

  // 에러 다이얼로그
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
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
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                BBISTI.bstiMent(user_bsti),
                style: const TextStyle(
                  fontSize: 19,
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
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ContentText(
                  text: BBISTI.bstiDescription(user_bsti), // BSTI 설명
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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
              widget.userData.routineId.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MainButton(
                        text: "나만의 루틴 시작하기",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddSkinCareMain(widget.userData),
                            ),
                          );
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: MainButton(
                        text: "대시보드 가기",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashPage(widget.userData),
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

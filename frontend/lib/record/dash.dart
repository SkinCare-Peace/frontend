import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final int criterion = 50;
  Map<DateTime, Map<String, int>> skinData = {};

  // 날짜 이동
  void updateDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
  }

  // GET 요청을 통해 데이터 가져오기
  Future<void> fetchSkinData() async {
    final uri = Uri.parse('http://3.34.5.57/statistics/${widget.userData.id}');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // statistics 부분 변환
        final Map<DateTime, Map<String, int>> convertedStatistics = {};
        (responseData['statistics'] as Map<String, dynamic>)
            .forEach((key, value) {
          final DateTime parsedDate =
              DateTime.parse(key); // String -> DateTime 변환

          // Key를 한글로 변환
          final Map<String, String> keyTranslation = {
            "acne": "여드름",
            "moisture": "건조도",
            "pigmentation": "색소침착",
            "wrinkle": "주름",
            "pore": "모공",
            "elasticity": "탄력",
          };

          // 변환된 데이터를 저장
          final translatedData = value
              .map((k, v) => MapEntry(keyTranslation[k] ?? k, v)); // 변환 후 저장

          convertedStatistics[parsedDate] =
              Map<String, int>.from(translatedData);
        });

        setState(() {
          skinData = convertedStatistics;
        });

        print('데이터 로드 성공: $convertedStatistics');
      } else if (response.statusCode == 404) {
        print('에러: Not Found (404)');
        _showErrorDialog('데이터를 찾을 수 없습니다.');
      } else if (response.statusCode == 422) {
        print('에러: Validation Error (422)');
        _showErrorDialog('요청이 유효하지 않습니다.');
      } else {
        print('알 수 없는 에러: ${response.statusCode}');
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
  void initState() {
    super.initState();
    fetchSkinData();
  }

  @override
  Widget build(BuildContext context) {
    final currentData = skinData[selectedDate] ?? {};

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 60, bottom: 30),
        child: Column(
          children: [
            // 사용자 정보 및 프로필
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentTextLeft(
                      text:
                          "${widget.userData.bsti} ${utf8.decode(widget.userData.name.runes.toList())}님의\n피부 데이터",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 10),
                    ContentTextLeft(
                      text:
                          "${utf8.decode(widget.userData.name.runes.toList())}님! 오늘도 화이팅해요!",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                Image.asset(
                  BBISTI.bstiBBI(widget.userData.bsti),
                  width: MediaQuery.of(context).size.width * 0.3,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 루틴 시작 및 기록 버튼
            MainButton(
              text: "루틴 시작하기",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutineStartPage(widget.userData),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            MainButton(
              text: "오늘 피부 기록하기",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoadingPage0(widget.userData),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // 통계 및 제품 관리 버튼
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
                          builder: (context) => Insight(widget.userData, skinData),
                        ),
                      );
                    },
                    child: const ContentText(
                      text: "결과 통계",
                      fontSize: 14,
                    ),
                  ),
                  const Text("|", style: TextStyle(fontSize: 25)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddedProduct(widget.userData),
                        ),
                      );
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
            // 날짜 변경 및 데이터 표시
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => updateDate(-1),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.greyBox,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${selectedDate.year}.${selectedDate.month.toString().padLeft(2, '0')}.${selectedDate.day.toString().padLeft(2, '0')}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => updateDate(1),
                ),
              ],
            ),
            Expanded(
              child: currentData.isNotEmpty
                  ? Scrollbar(
                      thumbVisibility: true, // 스크롤바 항상 표시
                      radius: const Radius.circular(20),
                      interactive: true,
                      child: ListView(
                        children: currentData.entries.map((entry) {
                          return ListTile(
                            title: Text(
                              entry.key,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: SizedBox(
                              height: 20, // ProgressIndicator의 높이를 지정
                              child: LinearProgressIndicator(
                                value: entry.value / 100,
                                color: entry.value >= criterion
                                    ? AppColors.positiveScore
                                    : AppColors.negativeScore,
                                backgroundColor:
                                    const Color.fromARGB(255, 240, 240, 240),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            trailing: Text(
                              "${entry.value}점",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : const Center(
                      child: ContentText(
                        text: "데이터가 없습니다.",
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

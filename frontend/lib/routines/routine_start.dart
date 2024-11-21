import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/dash.dart';
import 'package:frontend/Constants/colors.dart';

class RoutineStartPage extends StatefulWidget {
  @override
  _RoutineStartPageState createState() => _RoutineStartPageState();
}
class _RoutineStartPageState extends State<RoutineStartPage> {
  final List<Map<String, dynamic>> routineSteps = [
    {
      'name': '오일 클렌징 마사지',
      'time': '1분',
      'ingredients': ['어성초', '레티놀', '시카'],
      'product': '티스 딥 오프 클렌징 오일',
      'usage': '손 끝으로 클렌징 오일을 살살 도포해서 1~2분 문질러 주세요!',
    },
    {
      'name': '토너로 결정리하기',
      'time': '1분',
      'ingredients': ['알로에', '비타민C'],
      'product': '소영언니의 토너',
      'usage': '알아서 잘 하기',
    },
    {'name': '앰플 or 에센스 바르기', 'time': '1분'},
    {'name': '모델링 팩 하기', 'time': '15분'},
    {'name': '로션 바르기', 'time': '1분'},
    {'name': '슬리핑 크림 바르기', 'time': '1분'},
  ];

  late List<bool> isExpandedList; // 각 항목 확장 상태
  late List<Color> containerColors; // 각 항목의 컨테이너 색상
  int? activeTimerIndex; // 현재 실행 중인 타이머 index
  int remainingTime = 0; // 남은 시간
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isExpandedList = List<bool>.filled(routineSteps.length, false);
    containerColors = List<Color>.filled(routineSteps.length, const Color.fromARGB(184, 239, 238, 238));
  }

  // 총 소요시간 계산
  int calculateTotalTime() {
    int totalTime = 0;
    for (var step in routineSteps) {
      String timeString = step['time']!.replaceAll('분', '');
      totalTime += int.parse(timeString);
    }
    return totalTime;
  }

  // 타이머 시작
  void startTimer(int index) {
    // 이전 타이머가 있다면 취소
    if (timer != null) {
      timer!.cancel();
    }
    setState(() {
      activeTimerIndex = index;
      remainingTime = int.parse(routineSteps[index]['time']!.replaceAll('분', '')) * 60; // 초 단위 변환
      containerColors[index] = const Color.fromARGB(184, 239, 238, 238); // 초기화
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          activeTimerIndex = null; // 타이머 완료 초기화
          containerColors[index] = const Color.fromARGB(255, 220, 250, 216) ; // 타이머 완료 시 색상 변경
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalTime = calculateTotalTime(); // 총 소요시간 계산

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 30.0, left: 30, top: 80, bottom: 10),
            child: Text(
              '유지민 님에게 가장 잘 맞는 루틴',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30, bottom: 10),
            child: Text(
              '1일 2회 (총 소요시간 ${totalTime}분)',
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              itemCount: routineSteps.length,
              itemBuilder: (context, index) {
                bool isExpanded = isExpandedList[index];
                var step = routineSteps[index];
                return GestureDetector(
                  onTap: () {
                    startTimer(index); // 항목 클릭 시 타이머 시작
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: containerColors[index], // 각 항목의 컨테이너 색상
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/emoji/apple.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    step['name']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(step['time']!),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline), // i 아이콘 누르면 상세정보 출력됨
                                    onPressed: () {
                                      setState(() {
                                        isExpandedList[index] = !isExpandedList[index];
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (activeTimerIndex == index)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                '남은 시간: ${remainingTime ~/ 60}분 ${remainingTime % 60}초',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 77, 77, 77),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (isExpanded && step.containsKey('ingredients')) ...[
                            const SizedBox(height: 30),
                            const Text(
                              '추천 성분:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 5,
                              children: (step['ingredients'] as List<String>).map((ingredient) {
                                return Chip(
                                  label: Text(ingredient),
                                  backgroundColor: const Color.fromARGB(255, 216, 238, 217),
                                  side: const BorderSide(
                                    color: Color.fromARGB(184, 239, 238, 238),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 9),
                            const Text(
                              '추천 제품:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              step['product'] ?? '',
                              style: const TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 9),
                            const Text(
                              '사용 방법:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              step['usage'] ?? '',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ****************** 루틴 마치기 버튼 ****************** //
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 58),
                backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
              child: const Text(
                '루틴을 마쳤어요!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/loading/loading_page5.dart';
import 'package:http/http.dart' as http;
import 'complete.dart'; // 완료 페이지


class RoutineStartPage extends StatefulWidget {
  final UserData userData; // 유저 데이터

  const RoutineStartPage(this.userData, {super.key});

  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutineStartPage> {
  List<Map<String, dynamic>> routineSteps = []; // 루틴 단계 데이터
  late List<bool> isExpandedList; // 각 항목 확장 상태
  late List<Color> containerColors; // 각 항목 컨테이너 색상
  late List<bool> completedSteps; // 각 항목 완료 상태
  String selectedRoutine = "morning"; // 기본 아침 루틴
  int? activeTimerIndex; // 현재 실행 중인 타이머 index
  int remainingTime = 0; // 남은 시간
  Timer? timer;
  bool isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    determineRoutine(); // 현재 시간대에 따라 루틴 결정
    loadRoutineSteps(); // 루틴 데이터 로드
  }

  @override
  void dispose() {
    timer?.cancel(); // 타이머 취소
    super.dispose();
  }

  // 현재 시간대를 기준으로 루틴 결정
  void determineRoutine() {
    final now = DateTime.now();
    if (now.hour >= 5 && now.hour < 15) {
      selectedRoutine = "morning"; // 오전 5시 ~ 오후 3시
    } else {
      selectedRoutine = "evening"; // 그 외 시간
    }
    print("현재 루틴: $selectedRoutine");
  }

  // API 호출 함수
  Future<List<Map<String, dynamic>>> fetchRoutineSteps() async {
    final uri = Uri.parse('http://3.34.5.57/routine/user/${widget.userData.id}');
    print('요청 URL: $uri');

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);

        // 선택한 루틴(morning/evening) 데이터 반환
        return List<Map<String, dynamic>>.from(data[selectedRoutine + '_routine']);
      } else if (response.statusCode == 404) {
        print('루틴 데이터를 찾을 수 없습니다. user_id: ${widget.userData.id}');
        return []; // 빈 리스트 반환
      } else {
        throw Exception('루틴 요청 실패: ${response.body}');
      }
    } catch (e) {
      print('루틴 단계 데이터를 가져오는 중 오류 발생: $e');
      return [];
    }
  }

  // 루틴 데이터 로드
  void loadRoutineSteps() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    final steps = await fetchRoutineSteps();

    if (!mounted) return; // 위젯이 활성 상태인지 확인

    setState(() {
      routineSteps = steps; // API 응답 데이터를 루틴에 추가
      isExpandedList = List<bool>.filled(routineSteps.length, false);
      containerColors =
          List<Color>.filled(routineSteps.length, const Color.fromARGB(184, 239, 238, 238));
      completedSteps = List<bool>.filled(routineSteps.length, false);
      isLoading = false; // 로딩 완료
    });
  }

  // 총 소요시간 계산
  int calculateTotalTime() {
    int totalTime = 0;
    for (var step in routineSteps) {
      totalTime += step['time'] as int; // time이 정수형으로 응답된다고 가정
    }
    return totalTime;
  }

  // 타이머 시작
  void startTimer(int index) {
    if (completedSteps[index]) return;

    if (timer != null) {
      timer!.cancel();
    }

    setState(() {
      activeTimerIndex = index;
      remainingTime = (routineSteps[index]['time'] as num).toInt() * 60; // 초 단위 변환
      containerColors[index] = const Color.fromARGB(184, 239, 238, 238); // 색상 초기화
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          activeTimerIndex = null; // 타이머 완료 초기화
          containerColors[index] = const Color.fromARGB(255, 220, 250, 216); // 타이머 완료 시 색상 변경
          completedSteps[index] = true; // 완료 상태 설정
          checkAllCompleted(); // 모든 항목 완료 확인
        }
      });
    });
  }


  // 모든 항목을 완료했는지 확인
  void checkAllCompleted() {
    if (completedSteps.every((step) => step)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompletePage()),
      );
    }
  }

  // 완료 안 한 항목 확인
  List<String> getIncompleteSteps() {
    List<String> incompleteSteps = [];
    for (int i = 0; i < completedSteps.length; i++) {
      if (!completedSteps[i]) {
        incompleteSteps.add(routineSteps[i]['name']!);
      }
    }
    return incompleteSteps;
  }

// 안한 항목 팝업(알림주기 부분)
  void showIncompleteStepsDialog(BuildContext context, List<String> incompleteSteps) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ //핸들러부분
              Center(
                child: Container(
                  width: 70,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${utf8.decode(widget.userData.name.runes.toList())}님!다음 항목은 건너뛰시나요?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: incompleteSteps.map((step) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          step,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // 팝업 닫기
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '닫기',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  // 루틴 완료 버튼 동작
  void handleComplete(BuildContext context) {
    List<String> incompleteSteps = getIncompleteSteps(); // 미완료 항목 가져오기

    if (incompleteSteps.isEmpty) {
      // 모든 항목이 완료된 경우
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompletePage()), // complete.dart로 이동
      );
    } else {
      // 미완료 항목이 있는 경우 팝업 띄우기
      showIncompleteStepsDialog(context, incompleteSteps);
    }
  }
  @override
Widget build(BuildContext context) {
  return isLoading
      ? loadingPage5(widget.userData) // 로딩 중일 때 LoadingPage5 표시
      : Scaffold(
          backgroundColor: const Color(0xFFF7F7F7),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 80, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${utf8.decode(widget.userData.name.runes.toList())}님의 루틴',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '1일 2회 (총 소요시간 ${calculateTotalTime()}분)',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      '각 항목을 TAP 해서 타이머를 실행해 보세요!\ni를 누르면 사용 방법이 나와요!',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child:
                        ElevatedButton(
                          onPressed: () {}, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedRoutine == "morning"
                                ? const Color.fromARGB(255, 255, 245, 183) 
                                : const Color.fromARGB(255, 37, 53, 90), 
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            selectedRoutine == "morning" ? "오전 루틴" : "오후 루틴",
                            style: TextStyle(
                              color: selectedRoutine == "morning" ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),),
                        ),
                      ],
                    ),
                    
                  ],
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
                        startTimer(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: containerColors[index],
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
                                        step['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text('${step['time']}분'),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () {
                                      setState(() {
                                        isExpandedList[index] = !isExpandedList[index];
                                      });
                                    },
                                  ),
                                ],
                              ),
                              if (activeTimerIndex == index)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    '남은 시간: ${remainingTime ~/ 60}분 ${remainingTime % 60}초',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 111, 111, 111),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (isExpanded) ...[
                                const SizedBox(height: 10),
                                const Text('빈도:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("${step['frequency']}회"),
                                const SizedBox(height: 10),
                                const Text(
                                  '사용 방법:',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                Text('${step['instructions']}'),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  onPressed: () {
                    handleComplete(context); // 버튼 클릭 시 완료/미완료 확인 및 동작 수행
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
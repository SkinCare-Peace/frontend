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
  String selectedRoutine = "morning"; // 아침루틴을 기본으로함
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

  // 저장된 루틴 가져오기
  Future<List<Map<String, dynamic>>> fetchRoutineSteps() async {
    final uri =
        Uri.parse('http://3.34.5.57/routine/user/${widget.userData.id}');
    print('요청 URL: $uri');

    try {
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
      });

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);

        // 선택한 루틴(morning/evening) 데이터 반환
        return List<Map<String, dynamic>>.from(
            data[selectedRoutine + '_routine']);
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
      containerColors = List<Color>.filled(
          routineSteps.length, const Color.fromARGB(184, 239, 238, 238));
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
      remainingTime =
          (routineSteps[index]['time'] as num).toInt() * 60; // 초 단위 변환
      containerColors[index] =
          const Color.fromARGB(184, 239, 238, 238); // 색상 초기화
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
          containerColors[index] =
              const Color.fromARGB(255, 220, 250, 216); // 타이머 완료 시 색상 변경
          completedSteps[index] = true; // 완료 상태 설정
          checkAllCompleted(); // 모든 항목 완료 확인
        }
      });
    });
  }

  // 모든 항목을 완료했는지 확인
  Future<void> checkAllCompleted() async {
    if (completedSteps.every((step) => step)) {
      //루틴기록하기 요청
      await sendRoutineRecord();

      //compelete 이동
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CompletePage(userData: widget.userData)), //유저 데이터 넘기기
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
  void showIncompleteStepsDialog(
      BuildContext context, List<String> incompleteSteps) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //핸들러부분
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
                  fontSize: 20,
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
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // 건너뛸래요 누르면

                      onPressed: () {
                        bool hasCompletedAny =
                            completedSteps.any((step) => step); // 완료된 항목 확인
                        if (hasCompletedAny) {
                          // 완료된 항목이 하나라도 있으면 CompletePage로 이동함
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CompletePage(userData: widget.userData)),
                          );
                        } else {
                          // 완료된 항목 없으면 SnackBar 메시지 표시
                          Navigator.pop(context); // 팝업 닫기
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '하나라도 항목을 완료해 주세요!',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                            ),
                          );
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 201, 201, 201),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        '건너뛸래요!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 87, 204, 222),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 87, 204, 222)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        '바를래요!',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
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
  Future<void> handleComplete(BuildContext context) async {
  List<String> incompleteSteps = getIncompleteSteps(); // 미완료 항목 가져오기

  if (incompleteSteps.isEmpty) {
    // 모든 항목이 완료된 경우
    final success = await sendRoutineRecord(); // 루틴 기록요청  -> 성공일때만 
    
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompletePage(userData: widget.userData), // complete.dart로 이동
        ),
      );
    } else {
      // 루틴기록하기 요청 실패하면
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '기록 저장에 실패했습니다:( 다시 시도해주세요!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
      );
    }
  } else {
    // 미완료 항목이 있는 경우 팝업 띄우기
    showIncompleteStepsDialog(context, incompleteSteps);
  }
}


//루틴 실천했다고 기록 요청하기
Future<bool> sendRoutineRecord() async {
  final currentDate = DateTime.now().toIso8601String(); // 현재 날짜/시간 ISO 포맷
  final uri = Uri.parse('http://3.34.5.57/routine/record/${widget.userData.id}')
      .replace(queryParameters: {
    'date': currentDate,
  });

  try {
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      print('루틴 기록 추가 성공: 날짜 - $currentDate'); 
      return true; // 요청 성공
    } else {
      print('루틴 기록 추가 실패: ${response.body}');
      return false; // 요청 실패
    }
  } catch (e) {
    print('루틴 기록 추가 요청 중 오류 발생: $e');
    return false; // 요청 실패
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
                  padding: const EdgeInsets.only(
                      right: 25, left: 25, top: 80, bottom: 10),
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
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedRoutine == "morning"
                                    ? const Color.fromARGB(255, 255, 245, 183)
                                    : const Color.fromARGB(255, 37, 53, 90),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                selectedRoutine == "morning"
                                    ? "오전 루틴"
                                    : "오후 루틴",
                                style: TextStyle(
                                  color: selectedRoutine == "morning"
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
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
                      var step = routineSteps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // 항목 클릭 시 타이머 실행
                            if (!completedSteps[index]) {
                              startTimer(index);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: completedSteps[index]
                                  ? const Color.fromARGB(255, 220, 250, 216)
                                  : const Color.fromARGB(255, 240, 240, 240),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 첫 번째 행: 항목 이름, i 아이콘, 완료 버튼
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // 이미지, 이름, i 아이콘
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/emoji/apple.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          step['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '  ${step['time']}분',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.info_outline,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            // i 버튼 클릭 시 상세 정보 토글
                                            setState(() {
                                              isExpandedList[index] =
                                                  !isExpandedList[index];
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    // 완료 버튼
                                    GestureDetector(
                                      onTap: () {
                                        // 완료 여부 토글 및 타이머 취소
                                        setState(() {
                                          completedSteps[index] =
                                              !completedSteps[index];
                                          if (completedSteps[index] &&
                                              activeTimerIndex == index) {
                                            timer?.cancel();
                                            activeTimerIndex = null;
                                            remainingTime = 0;
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: completedSteps[index]
                                              ? const Color.fromARGB(
                                                  255, 87, 204, 222)
                                              : const Color.fromARGB(
                                                  255, 200, 200, 200),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // 두 번째 행: 타이머 표시 (해당 항목 활성화 시)
                                if (activeTimerIndex == index)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      '남은 시간: ${remainingTime ~/ 60}분 ${remainingTime % 60}초',
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 111, 111, 111),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                // 세 번째 행: 상세 정보 (i 아이콘 클릭 시 표시)
                                if (isExpandedList[index]) ...[
                                  const SizedBox(height: 10),
                                  const Text('빈도:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("${step['frequency']}회"),
                                  const SizedBox(height: 10),
                                  const Text(
                                    '사용 방법:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
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

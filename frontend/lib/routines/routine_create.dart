import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/loading/loading_page2.dart';
import 'package:frontend/routines/routine_sucessfuly_create.dart';
import 'package:url_launcher/url_launcher.dart'; // url 열기용
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoutinePage extends StatefulWidget {
  final int timeMinutes; // 시간
  final int moneyWon; // 돈
  final List<String> userConcerns; // 고민
  final UserData userData;

  const RoutinePage(this.userData, {
    required this.timeMinutes,
    required this.moneyWon,
    required this.userConcerns, // 고민 데이터 전달
    super.key,
  });


  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> routineSteps = [];
  late List<bool> isExpandedList;
  Map<String, Map<int, List<Map<String, dynamic>>>> recommendedCosmetics = {
    "morning": {}, // 아침 화장품
    "evening": {}, // 저녁 화장품
  };

  Map<String, List<Map<String, dynamic>>> routines = {
    "morning": [],
    "evening": [],
  }; // 낮/밤 루틴 저장
  String selectedRoutine = "morning"; // 기본은 낮으로
  String? routineId; //루틴id 저장

  // 소요 시간 계산 (낮밤 분리)
  int calculateTotalTime(String routineType) {
    int totalTime = 0;
    for (var step in routines[routineType] ?? []) {
      if (step['time'] != null) {
        totalTime += step['time'] as int;
      }
    }
    return totalTime;
  }

// 루틴 가져오기 *******************************************
// 루틴 생성 시 routineId 저장
  Future<Map<String, dynamic>> fetchRoutine({
    required int timeMinutes,
    required int moneyWon,
  }) async {
    final uri =
        Uri.parse("http://3.34.5.57/routine/").replace(queryParameters: {
      "time_minutes": timeMinutes.toString(),
      "money_won": moneyWon.toString(),
    });

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      print("보낸 시간 : ${timeMinutes}");
      print("보낸 돈 : ${moneyWon}");
      final decodedResponse = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> data = json.decode(decodedResponse);

      print("Fetched Routine Data: $data");
      // 루틴 ID 저장
      routineId = data['_id']; // 서버에서 반환된 루틴 ID 저장
      print("새로 가져온 Routine ID: $routineId");

      return {
        "morning_routine": data['morning_routine'] ?? [],
        "evening_routine": data['evening_routine'] ?? [],
      };
    } else {
      throw Exception("Failed to fetch routine: ${response.body}");
    }
  }

  // 추천 화장품 가져오기 ******************************************* (유저 스킨타입, 고민, 알러지 성분 보내기)
  Future<List<Map<String, dynamic>>> fetchRecommendedCosmetics({
    required String skinType,
    required String cosmeticType,
    required int budget, 
  }) async {
    final uri = Uri.parse("http://3.34.5.57/cosmetics/recommendation")
        .replace(queryParameters: {
      "user_skin_type": skinType, //지성, 건성
      "cosmetic_types": cosmeticType, //화장품 종류
      "budget": budget.toString(), //예산 (나눈값)
    });

    final requestBody = jsonEncode({
      "user_concerns": widget.userConcerns,
      "allergic_ingredients": ["parabens"],
    });

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      try {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
        print("화장품 추천 응답 : ${decodedResponse}");
        return List<Map<String, dynamic>>.from(data);
      } catch (e) {
        throw FormatException("Invalid JSON format: ${response.body}");
      }
    } else {
      throw Exception(
          "Failed to fetch recommended cosmetics: ${response.body}");
    }
  }

  // 루틴 불러오기 *******************************************
  Future<void> fetchAndUpdateRoutine() async {
    setState(() {
      isLoading = true; // 로딩 상태 시작
    });

    try {
      // 루틴 데이터를 가져옴
      final routineData = await fetchRoutine(
        timeMinutes: widget.timeMinutes,
        moneyWon: widget.moneyWon,
      );

      setState(() {
        routines["morning"] =
            List<Map<String, dynamic>>.from(routineData["morning_routine"]);
        routines["evening"] =
            List<Map<String, dynamic>>.from(routineData["evening_routine"]);
        updateRoutineSteps();
      });

      // 추천 화장품 데이터를 모두 로드
      await fetchAllCosmetics();

      setState(() {
        isLoading = false; // 로딩 상태 종료
      });
    } catch (e) {
      print("Error fetching routine: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("루틴 생성 중 오류 발생: $e")),
      );
      setState(() {
        isLoading = false; // 오류 발생 시 로딩 상태 종료
      });
    }
  }

  // 모든 추천 화장품 데이터 로드
  Future<void> fetchAllCosmetics() async {
    for (String routineType in ["morning", "evening"]) {
      for (int i = 0; i < routines[routineType]!.length; i++) {
        // 각 단계의 화장품 데이터를 비동기로 가져오기
        await fetchAndUpdateCosmetics(
            i, routines[routineType]![i]['name'], routineType);
      }
    }
  }

  // 현재 선택된 루틴에 따라 routineSteps 업데이트함 + 화장품도 다시 요청 *******************************************
  void updateRoutineSteps() {
    setState(() {
      routineSteps = routines[selectedRoutine] ?? [];
      isExpandedList = List<bool>.filled(routineSteps.length, false);
    });

    // 초기화 시 선택된 루틴의 화장품 데이터 요청
    for (int i = 0; i < routineSteps.length; i++) {
      if (!recommendedCosmetics[selectedRoutine]!.containsKey(i)) {
        fetchAndUpdateCosmetics(i, routineSteps[i]['name'], selectedRoutine);
      }
    }
  }

  // 화장품 불러오기 (낮/밤 루틴 구분 추가 -> 따로 저장해서 서로 영향 안끼치게)
  // 특정 단계의 추천 화장품 업데이트 ***********************************************************
  Future<void> fetchAndUpdateCosmetics(
      int index, String cosmeticType, String routineType) async {
    try {
      final int stepCount = routineSteps.length; // 루틴 단계 개수
      if (stepCount == 0) throw Exception("루틴 단계가 없습니다.");

      final int budgetPerStep =
          (widget.moneyWon / stepCount).floor(); // 단계별 예산 계산 ()
      final skinType =
          routineType == "morning" ? "건성" : "지성"; // 루틴에 따른 스킨 타입 설정

      final cosmetics = await fetchRecommendedCosmetics(
        skinType: skinType,
        cosmeticType: cosmeticType,
        budget: budgetPerStep,
      );

      setState(() {
        if (!recommendedCosmetics[routineType]!.containsKey(index)) {
          recommendedCosmetics[routineType]![index] = [];
        }
        recommendedCosmetics[routineType]![index] = cosmetics;
      });
    } catch (e) {
      print(
          "Error fetching cosmetics for step $index in $routineType routine: $e");
    }
  }

// 루틴 생성 중 로딩 페이지로 이동
  void goToLoadingPageAndFetchRoutine() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoadingPage2(widget.userData),
      ),
    );

    await fetchAndUpdateRoutine(); // 데이터 로드

    if (!isLoading) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoutinePage(
            widget.userData,
            timeMinutes: widget.timeMinutes,
            moneyWon: widget.moneyWon,
            userConcerns: widget.userConcerns,
          ),
        ),
      );
    }
  }

//루틴 갱신하기(저장하기)
  Future<void> updateRoutine(String routineId) async {
    final uri = Uri.parse("http://3.34.5.57/users/${widget.userData.id}");
    final requestBody = jsonEncode({
      "routine_id": routineId, //루틴 id 보내기
    });
    print("루틴id 서버에 전송중 = 루틴 id: $routineId"); // 루틴 ID 출력

    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: requestBody,
    );

    if (response.statusCode == 200) {
      print("루틴 저장 성공");
    } else {
      throw Exception("Failed to update routine: ${response.body}");
    }
  }

// ************************************************ UI *******************************************
  @override
  void initState() {
    super.initState();
    fetchAndUpdateRoutine(); //루틴 초기화
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingPage2(widget.userData); // 로딩 중일 때 표시할 페이지
    }
    int totalTime = calculateTotalTime(selectedRoutine);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                right: 30.0, left: 30, top: 80, bottom: 10),
            child: Text(
              '${utf8.decode(widget.userData.name.runes.toList())} 님에게 가장 잘 맞는 루틴',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 30.0, left: 30, bottom: 10),
            child: Text(
              '각 항목을 TAP 해서 추천제품을 확인해보세요!\ni를 누르면 제품 정보를 볼 수 있어요!\n루틴의 빈도에 맞춰 매일 알려드릴게요!',
              style: TextStyle(
                  color: Color.fromARGB(137, 52, 52, 52),
                  fontWeight: FontWeight.w600,
                  fontSize: 13),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 30, bottom: 10),
            child: Text(
              '${selectedRoutine == "morning" ? "아침" : "저녁"} 루틴 (총 소요시간 $totalTime분)',
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          // 낮/밤 선택 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRoutine = "morning";
                        updateRoutineSteps();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRoutine == "morning"
                          ? const Color.fromARGB(255, 255, 245, 183)
                          : const Color.fromARGB(255, 230, 230, 230),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "낮",
                      style: TextStyle(
                        color: selectedRoutine == "morning"
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedRoutine = "evening";
                        updateRoutineSteps();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedRoutine == "evening"
                          ? const Color.fromARGB(255, 37, 53, 90)
                          : const Color.fromARGB(255, 230, 230, 230),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "밤",
                      style: TextStyle(
                        color: selectedRoutine == "evening"
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 루틴 리스트
          Expanded(
            child: routineSteps.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 87, 204, 222)),
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    itemCount: routineSteps.length,
                    itemBuilder: (context, index) {
                      bool isExpanded = isExpandedList[index];
                      var step = routineSteps[index];
                      var cosmetics =
                          recommendedCosmetics[selectedRoutine]?[index] ?? [];
                      // 현재 선택된 낮밤 루틴에 맞춰서 접근
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpandedList[index] = !isExpandedList[index];
                            });

                            if (cosmetics.isEmpty) {
                              fetchAndUpdateCosmetics(
                                  index, step['name'], selectedRoutine);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(184, 239, 238, 238),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Text('${step['time']}분'),
                                  ],
                                ),
                                if (isExpanded) ...[
                                  const SizedBox(height: 30),
                                  const Text('사용 방법:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(step['instructions'] ?? "사용 방법 없음"),
                                  const SizedBox(height: 30),
                                  const Text('빈도:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text("${step['frequency']}일마다 1번"),
                                  const SizedBox(height: 10),
                                  const Text('추천 화장품:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  if (cosmetics.isEmpty)
                                    const Text(
                                      '추천 데이터를 불러오는 중입니다...',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey),
                                    )
                                  else
                                    Column(
                                      children: cosmetics.map((cosmetic) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Row(
                                            children: [
                                              if (cosmetic['image_url'] != null)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: Image.network(
                                                    cosmetic['image_url'],
                                                    height: 50,
                                                    width: 50,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return const Icon(
                                                          Icons.broken_image,
                                                          size: 50);
                                                    },
                                                  ),
                                                ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  cosmetic['name'] ??
                                                      '제품 이름 없음',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.info_outline),
                                                onPressed: () => {
                                                  showCosmeticDetails(
                                                      context, cosmetic)
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList(),
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
          const SizedBox(height: 20),
          // 하단 버튼
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (routineId != null) {
                      updateRoutine(routineId!); // 루틴 갱신 요청
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RoutineSuccessfullyCreated(widget.userData),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("루틴 ID가 없습니다. 먼저 새로운 루틴을 생성해주세요.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 58),
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    '이 루틴으로 결정 !',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: fetchAndUpdateRoutine, // 새로운 루틴 요청(이전꺼 초기화 로직 포함)
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 58),
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    '새로운 루틴 추천받기',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ************************************  화장품 정보 표시 다이얼로그 ************************************
void showCosmeticDetails(BuildContext context, Map<String, dynamic> cosmetic) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 30), // 다이얼로그 여백
        titlePadding:
            const EdgeInsets.only(top: 40, left: 30, right: 30), // 제목 여백
        contentPadding: const EdgeInsets.symmetric(horizontal: 30), // 내용 여백
        title: Center(
          child: Text(
            cosmetic['name'] ?? '제품 이름 없음',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        content: SizedBox(
          height: 400, 
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "${cosmetic['reason'] ?? '추천 이유 정보 없음'}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 15),
                if (cosmetic['image_url'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      cosmetic['image_url'],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 200);
                      },
                    ),
                  ),
                const SizedBox(height: 15),
                Text(
                  "브랜드: ${cosmetic['brand'] ?? '정보 없음'}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  "가격: ${cosmetic['selling_price'] ?? '정보 없음'}원",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                if (cosmetic['matching_ingredients'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: cosmetic['matching_ingredients']
                        .entries
                        .map<Widget>((entry) {
                      final concern = entry.key;
                      final ingredients = entry.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$concern에 좋은 성분이 들어있어요:",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: ingredients.entries
                                  .map<Widget>((ingredientEntry) {
                                return ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 187, 228, 235), // 버튼 색상
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                  child: Text(
                                    "${ingredientEntry.key}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                else
                  const Text(
                    "추천 성분 정보 없음",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final url = cosmetic['link'];
                    if (url != null && await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("유효하지 않은 링크입니다")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 106, 187, 198),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  child: const Text(
                    "구매 링크",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              '닫기',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.black
              ),
            ),
          ),
        ],
      );
    },
  );
}
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoutinePage extends StatefulWidget {
  final int timeMinutes; // 시간
  final int moneyWon; // 돈

  const RoutinePage({
    Key? key,
    required this.timeMinutes,
    required this.moneyWon,
  }) : super(key: key);

  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  List<Map<String, dynamic>> routineSteps = [];
  late List<bool> isExpandedList;
  Map<int, List<Map<String, dynamic>>> recommendedCosmetics = {}; // 추천 화장품 저장

  // 총 소요 시간 계산
  int calculateTotalTime() {
    int totalTime = 0;
    for (var step in routineSteps) {
      if (step['time'] != null) {
        String timeString = step['time']!.replaceAll('분', '');
        totalTime += int.parse(timeString);
      }
    }
    return totalTime;
  }

  // 루틴 가져오기
  Future<List<dynamic>> fetchRoutine({
    required int timeMinutes,
    required int moneyWon,
  }) async {

    print("Fetching routine with time: $timeMinutes, money: $moneyWon"); // 뭐 전송하는지 확인
    final uri = Uri.parse("http://00/routine").replace(queryParameters: {
      "time_minutes": timeMinutes.toString(),
      "money_won": moneyWon.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedResponse);
      return data['routine'];
    } else {
      throw Exception("Failed to fetch routine: ${response.body}");
    }
  }

  // 추천 화장품 가져오기
  Future<List<Map<String, dynamic>>> fetchRecommendedCosmetics({
    required String skinType,
    required String cosmeticType,
    required int budget,
  }) async {
    final uri = Uri.parse("http://00/cosmetics/recommendation").replace(queryParameters: {
      "user_skin_type": skinType,
      "cosmetic_types": cosmeticType,
      "budget": budget.toString(),
    });

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_concerns": ["dryness", "redness"], // 예시 데이터
        "allergic_ingredients": ["parabens"], // 예시 데이터
      }),
    );

    if (response.statusCode == 200) {
      try {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
        return List<Map<String, dynamic>>.from(data);
      } catch (e) {
        throw FormatException("Invalid JSON format: ${response.body}");
      }
    } else {
      throw Exception("Failed to fetch recommended cosmetics: ${response.body}");
    }
  }

  // 데이터 가져와서 UI 업데이트
  void fetchAndUpdateRoutine() async {
    try {
      final data = await fetchRoutine(
        timeMinutes: widget.timeMinutes,
        moneyWon: widget.moneyWon,
      );

      setState(() {
        routineSteps = List<Map<String, dynamic>>.from(data.map((item) {
          return {
            "name": item["name"] ?? "단계 이름 없음",
            "time": item["usage_time"] != null ? "${item["usage_time"].length}분" : "0분",
            "sequence": item["sequence"] ?? 0,
            "frequency": item["frequency"] ?? 0,
            "usage_time": item["usage_time"] ?? [],
          };
        })).toList();

        routineSteps.sort((a, b) => a['sequence'].compareTo(b['sequence']));
        isExpandedList = List<bool>.filled(routineSteps.length, false);
      });
    } catch (e) {
      print("Error fetching routine: $e");
    }
  }

  // 추천 화장품 요청 및 업데이트
  void fetchAndUpdateCosmetics(int index, String cosmeticType) async {
    try {
      final cosmetics = await fetchRecommendedCosmetics(
        skinType: "dry", // 임시 피부 타입
        cosmeticType: cosmeticType,
        budget: widget.moneyWon,
      );

      setState(() {
        recommendedCosmetics[index] = cosmetics;
      });
    } catch (e) {
      print("Error fetching cosmetics for step $index: $e");
      print("Query parameters: ${{
        "user_skin_type": "dry",
        "cosmetic_types": cosmeticType,
        "budget": widget.moneyWon.toString(),
      }}");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndUpdateRoutine(); // 초기 데이터 불러오기
  }

  @override
  Widget build(BuildContext context) {
    int totalTime = calculateTotalTime();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: routineSteps.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30.0, left: 30, top: 80, bottom: 10),
                  child: Text(
                    '유지민 님에게 가장 잘 맞는 루틴',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0, left: 30, bottom: 10),
                  child: Text(
                    '1일 2회 (총 소요시간 $totalTime분)',
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
                      var cosmetics = recommendedCosmetics[index] ?? [];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isExpandedList[index] = !isExpandedList[index];
                            });

                            if (cosmetics.isEmpty) {
                              fetchAndUpdateCosmetics(index, step['name']);
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
                                              fontSize: 16, fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                    Text(step['time']!),
                                  ],
                                ),
                                if (isExpanded) ...[
                                  const SizedBox(height: 30),
                                  const Text('빈도:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("${step['frequency']}회"),
                                  const SizedBox(height: 10),
                                  const Text('추천 화장품:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  if (cosmetics.isEmpty)
                                    const Text(
                                      '추천 데이터를 불러오는 중입니다...',
                                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                    )
                                  else
                                    ...cosmetics.map((cosmetic) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Image.network(
                                              cosmetic['img_url'] ?? '',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    cosmetic['name'] ?? '제품 이름 없음',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 14),
                                                  ),
                                                  Text(
                                                    cosmetic['brand'] ?? '브랜드 없음',
                                                    style: const TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  const SizedBox(height: 10),
                                  const Text('추천 시간대:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    children: (step['usage_time'] as List<dynamic>).map((time) {
                                      final String timeString = time.toString();
                                      Color chipColor;
                                      if (timeString == 'morning') {
                                        chipColor = const Color.fromARGB(255, 255, 249, 195)!;
                                      } else if (timeString == 'evening') {
                                        chipColor = const Color.fromARGB(255, 185, 223, 255)!;
                                      } else {
                                        chipColor = const Color.fromARGB(255, 216, 238, 217);
                                      }
                                      return Chip(
                                        label: Text(
                                          timeString == 'morning' ? '아침' : '저녁',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        backgroundColor: chipColor,
                                        side: BorderSide(color: chipColor),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: -4),
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

                // ************************** 하단 결정 버튼 **************************
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 루틴 결정시 동작 추가
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
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: fetchAndUpdateRoutine, // 새로운 루틴 요청
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 58),
                          backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Text(
                          '새로운 루틴 추천받기',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
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
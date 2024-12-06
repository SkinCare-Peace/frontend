
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/routines/routine_sucessfuly_create.dart';
import 'package:url_launcher/url_launcher.dart'; // url 열기용
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RoutinePage extends StatefulWidget {
  final int timeMinutes; // 시간
  final int moneyWon; // 돈
  final UserData userData;

  const RoutinePage(this.userData,
  {
    super.key,
    required this.timeMinutes,
    required this.moneyWon,
  });

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
  print("Fetching routine with time: $timeMinutes, money: $moneyWon");

  final uri = Uri.parse("http://3.34.5.57/routine/").replace(queryParameters: {
    "time_minutes": timeMinutes.toString(),
    "money_won": moneyWon.toString(),
  });

  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
  );

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
    final uri = Uri.parse("http://3.34.5.57/cosmetics/recommendation").replace(queryParameters: {
      "user_skin_type": skinType,
      "cosmetic_types": cosmeticType,
      "budget": budget.toString(),
    });

    final requestBody = jsonEncode({
      "user_concerns": ["건성", "지성"],
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
        return List<Map<String, dynamic>>.from(data);
      } catch (e) {
        throw FormatException("Invalid JSON format: ${response.body}");
      }
    } else {
      throw Exception("Failed to fetch recommended cosmetics: ${response.body}");
    }
  }

// 루틴 불러오기
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

// 화장품 불러오기
  void fetchAndUpdateCosmetics(int index, String cosmeticType) async {
    try {
      final String trimmedCosmeticType = cosmeticType.contains('/')
          ? cosmeticType.split('/').first.trim()
          : cosmeticType.trim();

      final cosmetics = await fetchRecommendedCosmetics(
        skinType: "건성",
        cosmeticType: trimmedCosmeticType,
        budget: widget.moneyWon,
      );

      setState(() {
        recommendedCosmetics[index] = cosmetics;
      });
    } catch (e) {
      print("Error fetching cosmetics for step $index: $e");
      print("Query parameters: ${{
        "user_skin_type": "건성",
        "cosmetic_types": cosmeticType,
        "budget": widget.moneyWon.toString(),
      }}");
    }
  }

// ************************************************ UI *******************************************
  @override
  void initState() {
    super.initState();
    fetchAndUpdateRoutine();
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
                                  const SizedBox(height: 10),
                                  if (cosmetics.isEmpty)
                                    const Text(
                                      '추천 데이터를 불러오는 중입니다...',
                                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                    )
                                  else
                                    Column(
                                      children: cosmetics.map((cosmetic) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Row(
                                            children: [
                                              
                                              if (cosmetic['image_url'] != null)
  ClipRRect(
    borderRadius: BorderRadius.circular(5), 
    child: Image.network(
      cosmetic['image_url'],
      height: 50,
      width: 50,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.broken_image, size: 50);
      },
    ),
  ),

                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  cosmetic['name'] ?? '제품 이름 없음',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 14),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(icon: const Icon(
                                                Icons.info_outline
                                              ),
                                              onPressed: () => {showCosmeticDetails(context, cosmetic)},
                                              )
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  const SizedBox(height: 10),
                                  const Text('추천 시간대:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    children: (step['usage_time'] as List<dynamic>).map((time) {
                                      final String timeString = time.toString();
                                      Color chipColor;
                                      if (timeString == 'morning') {
                                        chipColor = const Color.fromARGB(255, 255, 249, 195);
                                      } else if (timeString == 'evening') {
                                        chipColor = const Color.fromARGB(255, 185, 223, 255);
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoutineSuccessfullyCreated(widget.userData),
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


// ************************************  화장품 정보 표시 다이얼로그 ************************************ 
void showCosmeticDetails(BuildContext context, Map<String, dynamic> cosmetic) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 30), // 다이얼로그 여백
        titlePadding: const EdgeInsets.only(top: 40, left: 30, right: 30), // 제목 여백
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
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text("${cosmetic['reason'] ?? '추천 이유 정보 없음'}"),
              const SizedBox(height: 15),
              if (cosmetic['image_url'] != null)
              ClipRRect( borderRadius: BorderRadius.circular(10), 
              child: 
                Image.network(
                  cosmetic['image_url'],
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 300);
                  },
                ),),
              const SizedBox(height: 15),
              Text("브랜드: ${cosmetic['brand'] ?? '정보 없음'}",style: const TextStyle(
                 fontWeight: FontWeight.w600, 
                 fontSize: 12,
                 ),
              ),
              const SizedBox(height: 14),
              Text("가격: ${cosmetic['selling_price'] ?? '정보 없음'}원",style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16, 
                ),),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final url = cosmetic['link'];
                  if (url != null && await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(
                      Uri.parse(url), 
                      mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("유효하지 않은 링크입니다")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text(
                  "구매 링크",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              //const SizedBox(height: 20),
              //Text("총 점수: ${cosmetic['total_score'] ?? '정보 없음'}"),
              //Text("피부 타입 점수: ${cosmetic['skin_type_score'] ?? '정보 없음'}"),
              //Text("관심사 점수: ${cosmetic['concern_score'] ?? '정보 없음'}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('닫기', style: TextStyle(
            fontWeight: FontWeight.w400, 
            fontSize: 16, 
              ),
              )
            ,
          ),
        ],
      );
    },
  );
}

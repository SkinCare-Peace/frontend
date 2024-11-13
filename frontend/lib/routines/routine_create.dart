import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RoutinePage(),
    );
  }
}

class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}


// 백에서 각 정보 받아와서 입력
class _RoutinePageState extends State<RoutinePage> {
  final List<Map<String, dynamic>> routineSteps = [
    {
      'name': '오일 클렌징 마사지',
      'time': '3분',
      'ingredients': ['어성초', '레티놀', '시카'],
      'product': '티스 딥 오프 클렌징 오일',
      'usage': '손 끝으로 클렌징 오일을 살살 도포해서 1~2분 문질러 주세요!',
    },
    { 'name': '토너로 결정리하기', 
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

  late List<bool> isExpandedList;

  int calculateTotalTime() {
    int totalTime = 0;
    for (var step in routineSteps) {
      String timeString = step['time']!.replaceAll('분', '');
      totalTime += int.parse(timeString);
    }
    return totalTime;
  }

  @override
  void initState() {
    super.initState();
    isExpandedList = List<bool>.filled(routineSteps.length, false);
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
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '피부타입 : 수분이 부족한 건성\n'
                '유지민님은 건조도가 높아, 보습이 중요한 피부 타입입니다.\n'
                '수분을 가득 채워줄 다음과 같은 루틴을 생성해 봤어요!',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const SizedBox(height: 20),


           // ************************** 각 루틴 **************************
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              itemCount: routineSteps.length,
              itemBuilder: (context, index) {
                bool isExpanded = isExpandedList[index];
                var step = routineSteps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpandedList[index] = !isExpandedList[index];
                      });
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
                                    'assets/emoji/apple.png', // 사과 이미지 경로
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    step['name']!,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Text(step['time']!),
                            ],
                          ),
                          if (isExpanded && step.containsKey('ingredients')) ...[
                            const SizedBox(height: 30),
                            const Text('추천 성분:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 5,
                              children: (step['ingredients'] as List<String>).map((ingredient) {
                                return Chip(
                                  label: Text(ingredient),
                                  backgroundColor: const Color.fromARGB(255, 216, 238, 217),
                                  side: const BorderSide(color: Color.fromARGB(184, 239, 238, 238)),
                                  shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(20),), // 모서리 둥글게 설정
                                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, 
                                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: -4), 
                                  
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 9),
                            const Text('추천 제품:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(step['product'] ?? '', style: const TextStyle(color: Colors.black87)),
                            const SizedBox(height: 9),
                            const Text('사용 방법:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(step['usage'] ?? '', style: const TextStyle(color: Colors.black87)),
                            const SizedBox(height: 12),
                            Center(
                            child: Container(
                                height: 6,
                                width: 60, 
                                decoration: BoxDecoration(
                                color: Colors.grey[300],  
                                borderRadius: BorderRadius.circular(5),  
                                ),
                             ),
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
                  onPressed: () {},
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
                  onPressed: () {},
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

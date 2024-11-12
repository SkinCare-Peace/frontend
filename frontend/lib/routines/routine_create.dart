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

class RoutinePage extends StatelessWidget {
  final List<Map<String, String>> routineSteps = [
    {'name': '클렌징 티슈', 'time': '3분'},
    {'name': '오일 클렌징 마사지', 'time': '3분'},
    {'name': '폼 클렌징', 'time': '1분'},
    {'name': '토너로 결정리하기', 'time': '1분'},
    {'name': '앰플 or 에센스 바르기', 'time': '1분'},
    {'name': '모델링 팩 하기', 'time': '15분'},
    {'name': '로션 바르기', 'time': '1분'},
    {'name': '슬리핑 크림 바르기', 'time': '1분'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 30.0, left: 30, top:80, bottom: 10),
            child: Text(
              '유지민 님에게 가장 잘 맞는 루틴',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 30.0, left: 30, bottom: 10),
            child: Text(
              '1일 2회 (총 소요시간 15분)',
              style: TextStyle(color: Colors.grey),
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
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              itemCount: routineSteps.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
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
                              routineSteps[index]['name']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(routineSteps[index]['time']!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    '이 루틴으로 결정 !',
                    style: TextStyle(fontSize: 16,color: Colors.white,
                  ),
                ),),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
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

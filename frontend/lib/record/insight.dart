import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/layout/text.dart';
import 'package:fl_chart/fl_chart.dart';

class Insight extends StatefulWidget {
  final UserData userData; // UserData 필드 추가
  const Insight(this.userData, {super.key});

  @override
  State<Insight> createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  final List<String> items = ["수분", "모공", "여드름", "주름", "색소침착"];
  int selectedIndex = 0; // 선택된 항목 인덱스

  // 데이터 정의
  final Map<DateTime, Map<String, int>> skinData = {
    DateTime(2024, 8, 20): {
      "수분": 21,
      "모공": 27,
      "여드름": 74,
      "주름": 57,
      "색소침착": 32,
    },
    DateTime(2024, 8, 21): {
      "수분": 25,
      "모공": 30,
      "여드름": 70,
      "주름": 55,
      "색소침착": 28,
    },
    DateTime(2024, 8, 22): {
      "수분": 18,
      "모공": 25,
      "여드름": 20,
      "주름": 60,
      "색소침착": 40,
    },
  };

  @override
  Widget build(BuildContext context) {
    // 날짜 데이터 추출
    final List<DateTime> dates = skinData.keys.toList();
    final String selectedItem = items[selectedIndex];

    return Scaffold(
      backgroundColor: Colors.white, // 배경색 흰색
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TitleText(text: "피부 데이터 통계"),
            const ContentText_bk(text: "당신의 피부는 어떻게 변화하고 있을까요?"),
             SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            // 회색 컨테이너
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.greyBox,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 항목 선택 버튼
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: items.asMap().entries.map((entry) {
                            int index = entry.key;
                            String item = entry.value;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? Colors.blueAccent
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        skinData[dates.last]![item].toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        item,
                                        style: TextStyle(
                                          color: selectedIndex == index
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 그래프 영역
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int index = value.toInt();
                                      if (index >= dates.length) {
                                        return Container(); // 범위를 벗어나면 빈 위젯
                                      }
                                      // 날짜를 x축에 표시
                                      return Text(
                                        "${dates[index].month}.${dates[index].day}",
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 10, // y축 값 간격 설정
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(
                                    dates.length,
                                    (index) {
                                      final value = skinData[dates[index]]
                                              ?[selectedItem] ??
                                          0; // null일 경우 0으로 대체
                                      return FlSpot(
                                          index.toDouble(), value.toDouble());
                                    },
                                  ),
                                  isCurved: false, // 직선 그래프
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(show: false),
                                  color: Colors.blueAccent, // 그래프 선 색상
                                  barWidth: 3, // 선 두께
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

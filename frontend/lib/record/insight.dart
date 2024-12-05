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
      "수분": 90,
      "모공": 60,
      "여드름": 75,
      "주름": 96,
      "색소침착": 81,
    },
    DateTime(2024, 8, 21): {
      "수분": 45,
      "모공": 87,
      "여드름": 78,
      "주름": 90,
      "색소침착": 46,
    },
    DateTime(2024, 8, 22): {
      "수분": 90,
      "모공": 78,
      "여드름": 66,
      "주름": 89,
      "색소침착": 47,
    },
    DateTime(2024, 8, 25): {
      "수분": 95,
      "모공": 781,
      "여드름": 75,
      "주름": 89,
      "색소침착": 43,
    },
  };
  final int pivot = 80;

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
                  padding: const EdgeInsets.only(
                      top: 35, bottom: 20, left: 10, right: 10),
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

                            // 가장 최근 날짜의 점수
                            final int recentScore =
                                skinData[dates.last]?[item] ?? 0;
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: recentScore >= pivot
                                            ? AppColors
                                                .positiveScore // pivot 이상
                                            : AppColors.negativeScore,
                                        width:
                                            selectedIndex == index ? 4.5 : 1),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Text(
                                        item,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        skinData[dates.last]![item].toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: recentScore >= pivot
                                              ? AppColors
                                                  .positiveScore // pivot 이상
                                              : AppColors.negativeScore,
                                        ), // pivot 미만
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            recentScore >= pivot
                                                ? "좋음"
                                                : "관심 필요",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
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
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
                              child: SizedBox(
                                // 그래프 너비 동적 설정
                                width: dates.length > 6
                                    ? MediaQuery.of(context).size.width /
                                        6 *
                                        dates.length
                                    : MediaQuery.of(context)
                                        .size
                                        .width, // 그래프 너비 동적 설정
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
                                              style:
                                                  const TextStyle(fontSize: 12),
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
                                    borderData:
                                        FlBorderData(show: false), // 테두리 제거
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: List.generate(
                                          dates.length,
                                          (index) {
                                            final value = skinData[dates[index]]
                                                    ?[selectedItem] ??
                                                0;
                                            return FlSpot(index.toDouble(),
                                                value.toDouble());
                                          },
                                        ),
                                        isCurved: false, // 직선 그래프
                                        dotData: const FlDotData(
                                          show: true,
                                          // getDotPainter:
                                          //     (spot, percent, barData, index) {
                                          //   return FlDotCirclePainter(
                                          //     radius: 5, // 점 크기 설정
                                          //     color: recentScore >= pivot
                                          //         ? AppColors
                                          //             .positiveScore // pivot 이상
                                          //         : AppColors
                                          //             .negativeScore, // 점 색상 설정
                                          //     strokeWidth: 0, // 점 테두리 두께
                                          //     strokeColor: Colors
                                          //         .transparent, // 점 테두리 색상
                                          //   );
                                          // },
                                        ), // 점 색상 설정
                                        belowBarData: BarAreaData(show: false),
                                        color: const Color.fromARGB(
                                            255, 162, 162, 162), // 그래프 선 색상
                                        barWidth: 3, // 선 두께
                                      ),
                                    ],
                                    minX: 0, // x축 최소값
                                    maxX:
                                        dates.length - 1.toDouble(), // 최대 6개 표시
                                  ),
                                ),
                              ),
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

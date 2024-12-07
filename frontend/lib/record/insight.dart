import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/layout/text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/record/calendar.dart';
import 'package:frontend/record/calendar_post.dart';

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
      "수분": 80,
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
      "모공": 81,
      "여드름": 75,
      "주름": 89,
      "색소침착": 43,
    },
    DateTime(2024, 8, 26): {
      "수분": 89,
      "모공": 25,
      "여드름": 75,
      "주름": 16,
      "색소침착": 78,
    },
    DateTime(2024, 8, 28): {
      "수분": 95,
      "모공": 81,
      "여드름": 75,
      "주름": 89,
      "색소침착": 43,
    },
    DateTime(2024, 8, 29): {
      "수분": 96,
      "모공": 75,
      "여드름": 80,
      "주름": 85,
      "색소침착": 40,
    },
  };

  final int pivot = 80;
  Color dot = const Color.fromARGB(255, 162, 162, 162);

  late DateTime latestDate; // 가장 최근 날짜
  late int latestMoistureScore; // 가장 최근 "수분" 점수

  @override
  void initState() {
    super.initState();
    latestDate = skinData.keys.reduce((a, b) => a.isAfter(b) ? a : b);
    latestMoistureScore = skinData[latestDate]?["수분"] ?? 0;
    dot = chooseColor(latestMoistureScore, pivot);
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          List<DateTime> fetchedDates =
                              await fetchMarkedDates(widget.userData);
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: MediaQuery.of(context).size.height *
                                    0.9, // 모달 높이 크기
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white, // 모달 배경색
                                  borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(30), // 모달 좌상단 라운딩 처리
                                    topRight:
                                        Radius.circular(30), // 모달 우상단 라운딩 처리
                                  ),
                                ),
                                child: Calander(widget.userData,
                                    fetchedDates), // 모달 내부 디자인 영역
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                      const Text(
                        "루틴 달성 기록",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
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
                                    dot = chooseColor(recentScore, pivot);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: chooseColor(recentScore, pivot),
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
                                            color: chooseColor(
                                                recentScore, pivot)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            recentScore >= pivot
                                                ? " 좋음 "
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
                                width:
                                    //MediaQuery.of(context).size.height ,
                                    dates.length > 6
                                        ? MediaQuery.of(context).size.width /
                                            5 *
                                            dates.length
                                        : MediaQuery.of(context)
                                            .size
                                            .width, // 그래프 너비 동적 설정
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      verticalInterval: 1,
                                      getDrawingVerticalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey[350], // 수직선 색상
                                          strokeWidth: 0.5, // 수직선 두께
                                          dashArray: [5, 5], // 점선 스타일: 대시와 간격
                                        );
                                      },
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors
                                              .grey[350], // 수평선 색상 (연한 회색)
                                          strokeWidth: 0.5, // 수평선 두께
                                          dashArray: [5, 5], // 점선 스타일: 대시와 간격
                                        );
                                      },
                                    ),
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
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 10, // y축 값 간격 설정
                                          getTitlesWidget: (value, meta) {
                                            // y축 최대값과 최소값 계산
                                            final double minValue = ((skinData
                                                        .values
                                                        .map((e) =>
                                                            e[selectedItem] ??
                                                            0)
                                                        .reduce((a, b) =>
                                                            a < b ? a : b)) -
                                                    5)
                                                .toDouble();
                                            final double maxValue = ((skinData
                                                        .values
                                                        .map((e) =>
                                                            e[selectedItem] ??
                                                            0)
                                                        .reduce((a, b) =>
                                                            a > b ? a : b)) +
                                                    5)
                                                .toDouble();

                                            // 최소값과 최대값일 경우 빈 위젯 반환
                                            if (value == minValue ||
                                                value == maxValue) {
                                              return Container();
                                            }

                                            // 그 외 값만 표시
                                            return Text(
                                              value.toInt().toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      rightTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 10, // y축 값 간격 설정
                                          getTitlesWidget: (value, meta) {
                                            // y축 최대값과 최소값 계산
                                            final double minValue = ((skinData
                                                        .values
                                                        .map((e) =>
                                                            e[selectedItem] ??
                                                            0)
                                                        .reduce((a, b) =>
                                                            a < b ? a : b)) -
                                                    5)
                                                .toDouble();
                                            final double maxValue = ((skinData
                                                        .values
                                                        .map((e) =>
                                                            e[selectedItem] ??
                                                            0)
                                                        .reduce((a, b) =>
                                                            a > b ? a : b)) +
                                                    5)
                                                .toDouble();

                                            // 최소값과 최대값일 경우 빈 위젯 반환
                                            if (value == minValue ||
                                                value == maxValue) {
                                              return Container();
                                            }

                                            // 그 외 값만 표시
                                            return Text(
                                              value.toInt().toString(),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      topTitles: const AxisTitles(
                                          sideTitles: SideTitles(
                                              showTitles: false)), // 위쪽 x축 비활성화
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
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter:
                                              (spot, percent, barData, index) {
                                            return FlDotCirclePainter(
                                              radius: 5, // 점 크기 설정
                                              color: dot, // 점 색상 설정
                                              strokeWidth: 0, // 점 테두리 두께
                                              strokeColor: Colors
                                                  .transparent, // 점 테두리 색상
                                            );
                                          },
                                        ), // 점 색상 설정
                                        belowBarData: BarAreaData(show: false),
                                        color: const Color.fromARGB(
                                            255, 162, 162, 162), // 그래프 선 색상
                                        barWidth: 3, // 선 두께
                                      ),
                                    ],
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        getTooltipColor: (touchedSpot) =>
                                            Colors.black,
                                        tooltipRoundedRadius: 8, // 툴팁 모서리 반경
                                        fitInsideHorizontally:
                                            true, // 수평 방향에서 툴팁이 그래프 안에 유지되도록 설정
                                        fitInsideVertically:
                                            true, // 수직 방향에서 툴팁이 그래프 안에 유지되도록 설정
                                        getTooltipItems: (touchedSpots) {
                                          return touchedSpots.map((spot) {
                                            final index = spot.x.toInt();
                                            final date = dates[index];
                                            final value = skinData[date]
                                                    ?[selectedItem] ??
                                                0;
                                            return LineTooltipItem(
                                              "${date.year}년 ${date.month}월 ${date.day}일\n$value점",
                                              const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),

                                      handleBuiltInTouches: true, // 내장 터치 동작 사용
                                    ),
                                    minX: 0, // x축 최소값
                                    maxX:
                                        dates.length - 1.toDouble(), // 최대 6개 표시
                                    minY: ((skinData.values
                                                    .map((e) =>
                                                        e[selectedItem] ?? 0)
                                                    .reduce(
                                                      (a, b) => a < b ? a : b,
                                                    ) -
                                                9) ~/
                                            10) *
                                        10.toDouble(), // y축 최솟값
                                    maxY: ((skinData.values
                                                    .map((e) =>
                                                        e[selectedItem] ?? 0)
                                                    .reduce(
                                                      (a, b) => a > b ? a : b,
                                                    ) +
                                                9) ~/
                                            10) *
                                        10.toDouble(), // y축 최댓값
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

  Color chooseColor(int score, int pivot) {
    if (score >= pivot) {
      return AppColors.positivePoint; // pivot 이상
    }
    return AppColors.negativePoint;
  }
}

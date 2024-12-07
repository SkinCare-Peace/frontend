import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/layout/text.dart';
import 'package:table_calendar/table_calendar.dart';

class Calander extends StatefulWidget {
  final UserData userData;
  final List<DateTime> markedDates;
  const Calander(this.userData, this.markedDates, {super.key});

  @override
  State<Calander> createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();

    // markedDates는 이제 위젯 외부에서 주입받음
    List<DateTime> markedDates = widget.markedDates;

    if (markedDates.isEmpty) {
      // 만약 데이터가 비어 있다면 현재 날짜 기준으로 달력을 구성하거나
      // 특정 기본값을 줄 수 있음
      DateTime today = DateTime.now();
      _firstDay = DateTime(today.year, today.month, 1);
      _lastDay = DateTime(today.year, today.month + 1, 0);
      _focusedDay = today;
      return;
    }

    // 오늘 날짜
    DateTime today = DateTime.now();

    // markedDates를 정렬하여 가장 과거/최신 날짜 파악
    markedDates.sort((a, b) => a.compareTo(b));
    DateTime earliest = markedDates.first;
    DateTime latest = markedDates.last;

    // 가장 과거 날짜가 속한 달의 1일
    DateTime earliestMonthFirstDay = DateTime(earliest.year, earliest.month, 1);
    // 가장 최신 날짜가 속한 달의 마지막 날
    // 마지막 날 계산: 해당 달+1의 0일은 이전달의 마지막 날이 됨
    DateTime latestMonthLastDay = DateTime(latest.year, latest.month + 1, 0);

    // firstDay, lastDay를 설정할 때도 오늘 날짜를 포함하고 싶다면,
    // 오늘 날짜와 비교하여 firstDay는 둘 중 더 과거, lastDay는 둘 중 더 최신인 날짜로 설정
    // 오늘이 더 과거라면 firstDay를 오늘로, 아니라면 earliestMonthFirstDay로
    if (today.isBefore(earliestMonthFirstDay)) {
      _firstDay = today;
    } else {
      _firstDay = earliestMonthFirstDay;
    }

    // 오늘이 latestMonthLastDay보다 최신이라면 lastDay를 오늘로, 아니라면 latestMonthLastDay
    if (today.isAfter(latestMonthLastDay)) {
      _lastDay = today;
    } else {
      _lastDay = latestMonthLastDay;
    }

    // 포커스할 날짜는 오늘 날짜로 설정 (오늘이 범위 밖이라면 범위 내 다른 날짜로 설정할 수 있음)
    _focusedDay = today.isBefore(_firstDay)
        ? _firstDay
        : (today.isAfter(_lastDay) ? _lastDay : today);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleText(text: "${widget.userData.name}님의 루틴 실천 기록"),
              const SizedBox(width: 5),
              Image.asset("assets/BBIhappy.png", width: 50, height: 50),
            ],
          ),
          const SizedBox(height: 20),
          TableCalendar(
            // firstDay와 lastDay를 가장 과거/최신 날짜가 속한 달의 시작과 끝으로 설정
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,

            weekNumbersVisible: false,

            // 날짜 선택 비활성화
            selectedDayPredicate: (day) => false,
            onDaySelected: (selectedDay, focusedDay) {
              // 아무 동작 안 함
            },

            // 이벤트 로더를 이용해 마커 표시
            eventLoader: (day) {
              if (widget.markedDates.any((markedDate) =>
                  markedDate.year == day.year &&
                  markedDate.month == day.month &&
                  markedDate.day == day.day)) {
                return ["event"];
              }
              return [];
            },

            // 오늘 날짜 스타일
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: AppColors.marker, width: 1),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.black, // 원하는 색상으로 변경
                fontWeight: FontWeight.bold,
              ),
              selectedDecoration: const BoxDecoration(),
              selectedTextStyle: const TextStyle(color: Colors.black),
            ),

            // 마커 표시를 위한 CalendarBuilders 설정
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.marker,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

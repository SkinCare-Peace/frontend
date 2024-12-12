import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/layout/text.dart';
import 'package:table_calendar/table_calendar.dart';

class Calander extends StatefulWidget {
  final UserData userData;
  const Calander(this.userData, {super.key});

  @override
  State<Calander> createState() => _CalanderState();
}

class _CalanderState extends State<Calander> {
  Future<void> fetchRecords() async {
    final uri =
        Uri.parse('http://3.34.5.57/routine/record/${widget.userData.id}');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          records = List<Map<String, dynamic>>.from(data['records']);
          setupCalendar();
          isLoading = false;
        });
        print("~!!!~~! 루틴 완료 기록 $data");
      } else {
        print('Failed to fetch records: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching records: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime today = DateTime.now();

  late DateTime focusedDay = today;
  late DateTime firstDay = DateTime(today.year, today.month, 1);
  late DateTime _lastDay = DateTime(today.year, today.month + 1, 0);
  List<Map<String, dynamic>>? records; // GET 요청으로 받아올 데이터
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  void setupCalendar() {
    // records가 null이면 빈 리스트로 초기화
    List<DateTime> markedDates = (records ?? [])
        .map((record) => DateTime.parse(record['date']))
        .toList();

    if (markedDates.isEmpty) {
      firstDay = DateTime(today.year, today.month, 1);
      _lastDay = DateTime(today.year, today.month + 1, 0);
      focusedDay = today;
      return;
    }

    markedDates.sort((a, b) => a.compareTo(b));
    DateTime earliest = markedDates.first;
    DateTime latest = markedDates.last;
    firstDay = earliest.isBefore(today) ? earliest : today;
    _lastDay = latest.isAfter(today) ? latest : today;
    focusedDay = today.isBefore(firstDay)
        ? firstDay
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
              TitleText(
                  text:
                      "${utf8.decode(widget.userData.name.runes.toList())}님의 루틴 실천 기록"),
              const SizedBox(width: 5),
              Image.asset("assets/BBIhappy.png", width: 50, height: 50),
            ],
          ),
          const SizedBox(height: 20),
          TableCalendar(
            // firstDay와 lastDay를 가장 과거/최신 날짜가 속한 달의 시작과 끝으로 설정
            firstDay: firstDay,
            lastDay: _lastDay,
            focusedDay: focusedDay,

            weekNumbersVisible: false,

            // 날짜 선택 비활성화
            selectedDayPredicate: (day) => false,
            onDaySelected: (selectedDay, focusedDay) {
              // 아무 동작 안 함
            },

            // 이벤트 로더를 이용해 마커 표시
            eventLoader: (day) {
              if (records == null || records!.isEmpty) {
                return []; // records가 null이거나 비어 있으면 마커 표시 안 함
              }

              // 해당 날짜와 일치하는 기록 검색
              final Map<String, dynamic> record = records!.firstWhere(
                (record) =>
                    DateTime.parse(record['date']).year == day.year &&
                    DateTime.parse(record['date']).month == day.month &&
                    DateTime.parse(record['date']).day == day.day,
                orElse: () => <String, dynamic>{}, // nullable 처리
              );

              // `morning`과 `evening` 값 확인
              final hasMorning =
                  record['morning'] != null && record['morning'].isNotEmpty;
              final hasEvening =
                  record['evening'] != null && record['evening'].isNotEmpty;

              // 조건에 따라 이벤트 반환
              if (hasMorning && hasEvening) {
                return ['full']; // 꽉 찬 동그라미
              } else if (hasMorning || hasEvening) {
                return ['empty']; // 빈 동그라미
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
                  if (events.contains('full')) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.marker, // 꽉 찬 동그라미
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  } else if (events.contains('empty')) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.marker,
                            width: 1.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }
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

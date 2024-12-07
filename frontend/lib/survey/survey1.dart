import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/layout/text.dart';
import 'package:frontend/survey/survey2.dart';
import 'package:frontend/survey/survey_info.dart';

class Survey1 extends StatefulWidget {
  final UserData userData;
  final SurveyInfo surveyInfo;

  const Survey1(
    this.userData, this.surveyInfo,{
    super.key,
    required ,
  });

  @override
  _Survey1State createState() => _Survey1State();
}

class _Survey1State extends State<Survey1> {
  String? _selectedOption;

  final List<Map<String, dynamic>> options = [
    {'label': '느껴지지 않는다.', 'oil': 0},
    {'label': '직후는 아니지만, 일정 시간이 지나면 느껴진다.', 'oil': 20},
    {'label': '세수하고 물이 마르면서 느껴진다.', 'oil': 50},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '세수 후 얼굴이 당기거나\n조여지는 느낌을 받나요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const ContentText(text: "(아무것도 바르지 않은 상태에서)"),
              const SizedBox(height: 40),
              ...options.map((option) => _buildCustomRadioOption(option)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_selectedOption != null) {
                    final selected = options
                        .firstWhere((o) => o['label'] == _selectedOption);
                    widget.surveyInfo.oil = selected['oil'];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Survey2(
                          userData: widget.userData,
                          surveyInfo: widget.surveyInfo,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('하나의 옵션을 선택해주세요!'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  child: Text(
                    '다음 질문으로',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  Widget _buildCustomRadioOption(Map<String, dynamic> option) {
    return Column(
      children: [
        ListTile(
          title: Text(
            option['label'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          trailing: Transform.scale(
            scale: 1.5,
            child: Radio<String>(
              value: option['label'],
              groupValue: _selectedOption,
              onChanged: (String? value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              activeColor: const Color.fromARGB(255, 87, 204, 222),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}

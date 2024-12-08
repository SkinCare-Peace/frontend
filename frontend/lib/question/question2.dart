import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/question/question3.dart';

class QuestionPage2 extends StatefulWidget {
  final UserData userData;

  const QuestionPage2(this.userData, {super.key,});
  @override
  _QuestionPage2State createState() => _QuestionPage2State();
}

class _QuestionPage2State extends State<QuestionPage2> {
  // 선택된 항목
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['1분', '5분', '10분', '20분', '30분 이상'];

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '하루에 피부관리에 몇분을 \n 투자하실 수 있나요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              ...options.map((option) {
                return Column(
                  children: [
                    _buildCustomRadioOption(option),
                    const SizedBox(height: 18),
                  ],
                );
              }),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_selectedOption != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPage3(
                         widget.userData , timeMinutes: _selectedOption!, // 선택된 시간을 전달
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

  Widget _buildCustomRadioOption(String label) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      trailing: Transform.scale(
        scale: 1.5, // 라디오 버튼 크기 조정
        child: Radio<String>(
          value: label,
          groupValue: _selectedOption,
          onChanged: (String? value) {
            setState(() {
              _selectedOption = value; // 선택된 값 변경
            });
          },
          activeColor: const Color.fromARGB(255, 87, 204, 222),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/routines/routine_create.dart';

class QuestionPage3 extends StatefulWidget {
  final String timeMinutes; // 설문2에서 전달된 시간 데이터

  const QuestionPage3({Key? key, required this.timeMinutes}) : super(key: key);

  @override
  _QuestionPage3State createState() => _QuestionPage3State();
}

class _QuestionPage3State extends State<QuestionPage3> {
  // 선택된 항목
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['10,000', '30,000', '50,000', '100,000'];

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
                '피부에 얼마를 투자하실\n수 있나요?',
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
              }).toList(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_selectedOption != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoutinePage(
                          timeMinutes: int.parse(widget.timeMinutes.replaceAll(RegExp(r'[^0-9]'), '')), // 숫자만 추출
                          moneyWon: int.parse(_selectedOption!.replaceAll(RegExp(r'[^0-9]'), '')), // 숫자만 추출
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
                    '제출하기',
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

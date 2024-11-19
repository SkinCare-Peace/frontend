import 'package:flutter/material.dart';
import 'package:frontend/question/question1.dart';
import 'package:frontend/question/question3.dart';


class QuestionPage3 extends StatefulWidget {
  @override
  _QuestionPage3State createState() => _QuestionPage3State();
}

class _QuestionPage3State extends State<QuestionPage3> {
  // 선택된 제품들 저장할 map
  final Map<String, bool> _selectedProducts = {
    '1만원': false,
    '3만원': false,
    '5만원': false,
    '10만원' : false,
    '상관없어요': false,
  };

  @override
  Widget build(BuildContext context) {
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
              ..._selectedProducts.keys.map((product) {
                return Column(
                  children: [
                    _buildCustomCheckboxOption(product), // 만든 체크박스
                    const SizedBox(height: 18), // 항목 간격 조절
                  ],
                );
              }).toList(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionPage1()), // 다음 질문으로 넘어감
                      );
        
                  // 제출 버튼 클릭 시의 동작
                  List<String> selectedItems = _selectedProducts.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  print('${selectedItems}');

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // 배경 색상
    );
  }

  // 커스텀 체크박스 
  Widget _buildCustomCheckboxOption(String label) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25, // 글씨 크기 크게
        ),
      ),
      trailing: Transform.scale(
        scale: 1.5, // 체크박스 크기 조정
        child: Checkbox(
          shape: const CircleBorder(), // 체크박스 동그라미
          value: _selectedProducts[label],
          onChanged: (bool? value) {
            setState(() {
              _selectedProducts[label] = value ?? false;
            });
          },
          activeColor: const Color.fromARGB(255, 87, 204, 222), // 선택된 체크박스 색상 주기
        ),
      ),
    );
  }
}

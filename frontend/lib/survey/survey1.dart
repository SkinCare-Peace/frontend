import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/question/question2.dart';

class QuestionPage1 extends StatefulWidget {
  final UserData userData;

  const QuestionPage1(this.userData, {super.key});

  @override
  _QuestionPage1State createState() => _QuestionPage1State();
}

class _QuestionPage1State extends State<QuestionPage1> {
  // 선택된 제품들 저장할 map
  final Map<String, bool> _selectedProducts = {
    '선크림': false,
    '폼 클렌징': false,
    '로션': false,
    '마스크팩': false,
    '립밤': false,
    '올인원': false,
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
                '스킨케어 제품 중 자주 사용해본 제품을 선택해주세요',
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
              }),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                   Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionPage2(widget.userData)), // 다음 질문으로 넘어감
                      );
        
                  // 제출 버튼 클릭 시의 동작
                  List<String> selectedItems = _selectedProducts.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  print('$selectedItems');

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

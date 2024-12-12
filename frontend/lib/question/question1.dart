// user_concerns 설문
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
    '여드름': false,
    '피지': false,
    '블랙헤드': false,
    '각질': false,
    '흉터': false,
    '모공': false,
    '홍조': false,
    '다크서클': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40,bottom: 20), // 화면 전체에 패딩 추가
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '현재 피부고민을 가지고 있나요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  '없다면 건너 뛰셔도 돼요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                const SizedBox(height: 30),
                ..._selectedProducts.keys.map((product) {
                  return Column(
                    children: [
                      _buildCustomCheckboxOption(product), // 만든 체크박스
                      const SizedBox(height: 10), // 항목 간격 조절
                    ],
                  );
                }),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    //선택 항목 추출하고,
                    List<String> selectedItems = _selectedProducts.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();
                    print('선택한 user_concern : $selectedItems');

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPage2(
                          widget.userData,
                          userConcerns: selectedItems, //userConcerns 전달
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
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
          fontSize: 23,
        ),
      ),
      trailing: Transform.scale(
        scale: 1.5, // 체크박스 크기 조정
        child: Checkbox(
          shape: const CircleBorder(),
          value: _selectedProducts[label],
          onChanged: (bool? value) {
            setState(() {
              _selectedProducts[label] = value ?? false;
            });
          },
          activeColor: const Color.fromARGB(255, 87, 204, 222),
        ),
      ),
    );
  }
}

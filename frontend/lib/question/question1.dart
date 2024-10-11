import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  // 선택된 제품들 저장할 map
  Map<String, bool> _selectedProducts = {
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
          decoration: BoxDecoration(
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
                  fontSize: 27,
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
                  // 제출 버튼 클릭 시의 동작
                  List<String> selectedItems = _selectedProducts.entries
                      .where((entry) => entry.value)
                      .map((entry) => entry.key)
                      .toList();

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          selectedItems.isNotEmpty
                              ? '${selectedItems.join(', ')}를 선택했습니다.'
                              : '아무것도 선택하지 않았습니다.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 87, 204, 222),
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
          shape: CircleBorder(), // 체크박스 동그라미
          value: _selectedProducts[label],
          onChanged: (bool? value) {
            setState(() {
              _selectedProducts[label] = value ?? false;
            });
          },
          activeColor: Color.fromARGB(255, 87, 204, 222), // 선택된 체크박스 색상 주기
        ),
      ),
    );
  }
}

// survey4.dart
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/face_detection/face_result.dart';
import 'package:frontend/survey/survey_info.dart';
// 필요하다면 SurveyComplete 같은 다음 페이지 import

class Survey4 extends StatefulWidget {
  final UserData userData;
  final SurveyInfo surveyInfo;

  const Survey4({
    super.key,
    required this.userData,
    required this.surveyInfo,
  });

  @override
  _Survey4State createState() => _Survey4State();
}

class _Survey4State extends State<Survey4> {
  String? _selectedOption; // '네' 또는 '아니오'

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['네', '아니오'];

    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '코나 턱에 까만 점을 짜면 노란 피지가 나옵니까?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
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
                    // "네"면 pizi = true, "아니오"면 pizi = false
                    widget.surveyInfo.pizi = (_selectedOption == '네');
                                        Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BSTI(widget.userData),
                      ),
                    );
                    // 여기서 다음 페이지로 이동하거나,
                    // 데이터를 서버로 전송하는 로직을 추가할 수 있습니다.
                    // 예: Navigator.push(...);
                    // 또는 단순히 print로 확인:
                    //print('피지 상태: ${widget.surveyInfo.pizi}');
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
                    '완료하기',
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
      backgroundColor: Colors.white,
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
        scale: 1.5,
        child: Radio<String>(
          value: label,
          groupValue: _selectedOption,
          onChanged: (String? value) {
            setState(() {
              _selectedOption = value;
            });
          },
          activeColor: const Color.fromARGB(255, 87, 204, 222),
        ),
      ),
    );
  }
}

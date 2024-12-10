// survey4.dart
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/Constants/which_bsti.dart';
import 'package:frontend/face_detection/face_result.dart';
import 'package:frontend/layout/text.dart';
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
                '블랙헤드가 고민인가요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const ContentText(
                  text: "(오돌토돌하거나 검정 점 같은 부분을\n압출하면 나오는 노란색 피지)"),
              const SizedBox(height: 20),
              Image.asset(
                "assets/images/pizi.jpg",
                width: 200,
                fit: BoxFit.fitWidth,
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
                    final String userBSTI = DecideBSTI.whichBSTI(widget.surveyInfo, widget.userData);
                    // 위 userBSTI string을 사용자 정보로 push하는 api 추가
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BSTI(widget.userData),
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

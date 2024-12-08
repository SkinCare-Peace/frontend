// survey3.dart
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/layout/text.dart';
import 'package:frontend/survey/survey_info.dart';
import 'package:frontend/survey/survey4.dart';

class Survey3 extends StatefulWidget {
  final UserData userData;
  final SurveyInfo surveyInfo;

  const Survey3({
    super.key,
    required this.userData,
    required this.surveyInfo,
  });

  @override
  _Survey3State createState() => _Survey3State();
}

class _Survey3State extends State<Survey3> {
  String? _selectedOption; // '그렇다' 또는 '없다'
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['그렇다', '없다'];

    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '아토피나 알러지가 있나요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const ContentText(text: "(알고 있는 성분이 있으면 적어주세요)"),
                const SizedBox(height: 40),
                ...options.map((option) {
                  return Column(
                    children: [
                      _buildCustomRadioOption(option),
                      const SizedBox(height: 18),
                    ],
                  );
                }),
                if (_selectedOption == '그렇다') ...[
                  const SizedBox(height: 20),
                  const Text(
                    '알고 있는 성분을 적어주세요',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '예: 특정 향료 등',
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedOption != null) {
                      if (_selectedOption == '그렇다') {
                        widget.surveyInfo.allergy = _controller.text;
                        widget.surveyInfo.sensitive2 = true;
                      } else {
                        widget.surveyInfo.allergy = '';
                        widget.surveyInfo.sensitive2 = false;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Survey4(
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
          fontSize: 20,
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

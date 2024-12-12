import 'package:flutter/material.dart';
import 'package:frontend/Constants/bsti_put.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/Constants/which_bsti.dart';
import 'package:frontend/face_detection/acne_data.dart';
import 'package:frontend/face_detection/face_result.dart';
import 'package:frontend/layout/text.dart';
import 'package:frontend/record/score_data.dart';
import 'package:frontend/survey/survey_info.dart';
import 'package:frontend/survey/survey4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
                  onPressed: _handleNextQuestion,
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

  Future<void> _handleNextQuestion() async {
    if (_selectedOption != null) {
      if (_selectedOption == '그렇다') {
        widget.surveyInfo.allergy = _controller.text;
        widget.surveyInfo.sensitive2 = true;
      } else {
        widget.surveyInfo.allergy = '';
        widget.surveyInfo.sensitive2 = false;
      }

      // PUT 요청 전송
      final response = await _sendDataToServer();

      if (response.statusCode == 200) {
        // 성공적으로 전송한 경우
         final String userBSTI = DecideBSTI.whichBSTI(
                        widget.surveyInfo, widget.userData);
                    updateBSTIStatus(
                        userBSTI, widget.userData); // bsti를 사용자 정보로 put
                    // 위 userBSTI string을 사용자 정보로 push하는 api 추가
                    widget.userData.bsti = userBSTI;
                    final acne = acneDataStore.getMinScore();
                    dashScore.saveData('acne', acne!);
                    dashScore.postData(widget.userData.id);



        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BSTI(widget.userData),
          ),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('서버를 찾을 수 없습니다.'),
          ),
        );
      } else if (response.statusCode == 402) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('데이터 유효성 검사에 실패했습니다.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('알 수 없는 오류가 발생했습니다.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('하나의 옵션을 선택해주세요!'),
        ),
      );
    }
  }

  Future<http.Response> _sendDataToServer() async {
    String url = 'http://3.34.5.57/users/${widget.userData.id}'; // API URL 변경
    final Map<String, dynamic> body = {
      "avoid_ingredients":
          _controller.text.isNotEmpty ? [_controller.text] : [], // 텍스트 필드 데이터
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      return response;
    } catch (e) {
      debugPrint('서버 요청 오류: $e');
      rethrow;
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

Future<void> userRegister() async {
  final response = await http.get(
    Uri.parse('http://3.34.5.57/users/'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final loginUrl = responseData['url'];

    if (await canLaunchUrl(loginUrl)) {
      await launchUrl(loginUrl);
    } else {
      throw 'Could not launch $loginUrl';
    }
  } else {
    print('회원가입 URL 요청 실패: ${response.statusCode}');
  }
}

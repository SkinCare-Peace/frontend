import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

Future<void> initiateGoogleLogin() async {
  final response = await http.get(
    Uri.parse('https://your-backend.com/auth/login'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final loginUrl = responseData['url'];

    if (await canLaunchUrl(loginUrl)) {
      await launchUrl(loginUrl); // 브라우저로 로그인 페이지 열기
    } else {
      throw 'Could not launch $loginUrl';
    }
  } else {
    print('로그인 URL 요청 실패: ${response.statusCode}');
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/notification/notifications.dart';
import 'package:frontend/notification/websocket_manager.dart';
import 'package:frontend/record/dash.dart';
import 'package:frontend/loading/loading_page0.dart';
import 'package:frontend/logIn/login_post.dart';
import 'package:frontend/Constants/user_data.dart';

class LoginInput extends StatelessWidget {
  LoginInput({super.key});

  final TextEditingController _emailController = TextEditingController();
  final NotificationService _notificationService = NotificationService();
  WebSocketManager? _webSocketManager;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/background.png'), // 배경 이미지
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent, // 배경색을 투명으로 설정
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/BBIhappy.png',
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            0.25,
                      ),
                      const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: '이메일',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const TextField(
                        decoration: InputDecoration(
                          labelText: '비밀번호',
                        ),
                        keyboardType: TextInputType.text,

                        obscureText: true, // 비밀번호 안보이도록 하는 것
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            0.05,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final userData =
                              await fetchUserData(_emailController.text);
                          if (userData != null && !isUserDataEmpty(userData)) {
                            print("로그인 성공! $userData");
                            // WebSocket 연결
                            _webSocketManager =
                                WebSocketManager(userId: userData.id);
                            _webSocketManager!.connect((message) {
                              // 메시지 처리: WebSocket 메시지를 알림으로 표시
                              final data = json.decode(message);
                              final String title = data['title'] ?? "알림";
                              final String body = data['body'] ?? "내용 없음";
                              final String image = data['image'] ?? "";
                              _notificationService.showNotification(
                                  title, body, image);
                            });
                            if (userData.skinType.isEmpty) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoadingPage0(userData),
                                  ));
                            } else {
                              if (userData.skinType.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashPage(userData),
                                    ));
                              }
                            }
                          } else {
                            print("로그인에 실패했습니다.");
                          } // 추후 팝업으로 변경 필요
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 35.0,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

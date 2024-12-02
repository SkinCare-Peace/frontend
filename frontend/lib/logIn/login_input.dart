import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/logIn/login_post.dart';

class LoginInput extends StatelessWidget {
  const LoginInput({super.key});

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
                      const TextField(
                        decoration: InputDecoration(labelText: '이름'),
                        keyboardType: TextInputType.text,
                      ),
                      const TextField(
                        decoration: InputDecoration(labelText: '이메일'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const TextField(
                        decoration: InputDecoration(labelText: '비밀번호'),
                        keyboardType: TextInputType.text,
                        obscureText: true, // 비밀번호 안보이도록 하는 것
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            0.05,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          userRegister();
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

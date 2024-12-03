import 'package:flutter/material.dart';
import 'package:frontend/buttonLayout/text.dart';
import 'package:frontend/logIn/login_input.dart';
import 'package:frontend/logIn/signup_input';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            padding:
                const EdgeInsets.only(top: 50, bottom: 90, left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "피부케어\n스마트하게",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset('assets/BBI.png'),
                const TitleText(text: "with BBI"),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginInput(),
                                ));
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(fontSize: 20),
                          )),
                      const Text("|", style: TextStyle(fontSize: 25)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupInput(),
                              ));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontSize: 20),
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

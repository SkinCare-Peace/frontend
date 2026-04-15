import 'package:flutter/material.dart';
import 'package:frontend/Constants/colors.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/loading/loading_page0.dart';
import 'package:frontend/logIn/register_post.dart';

class SignupInput extends StatelessWidget {
  SignupInput({
    super.key,
  }); // const 제거

  // TextEditingController는 mutable 객체이므로 final로 선언
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

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
                        'assets/BBImask.png',
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            0.15,
                      ),
                      const Text(
                        "Sign up",
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '이름',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: '이메일'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: '비밀번호'),
                        keyboardType: TextInputType.text,
                        obscureText: true, // 비밀번호 안보이도록 하는 것
                      ),
                                            TextField(
                        controller: _ageController,
                        decoration: const InputDecoration(labelText: '나이 (숫자만 입력)'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                MediaQuery.of(context).viewInsets.bottom) *
                            0.05,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_nameController.text.isEmpty || 
                              _emailController.text.isEmpty || 
                              _passwordController.text.isEmpty || 
                              _ageController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('모든 필드를 입력해주세요.')),
                            );
                            return;
                          }
                          
                          int? age = int.tryParse(_ageController.text);
                          if (age == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('나이는 숫자로 입력해주세요.')),
                            );
                            return;
                          }

                          try {
                            final userData = await userRegister(
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                                age);
                            if (userData != null && !isUserDataEmpty(userData)) {
                              print("회원가입 성공! $userData");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoadingPage0(userData),
                                  ));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('회원가입에 실패했습니다. 이미 등록된 이메일일 수 있습니다.')),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('에러가 발생했습니다: $e')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainColor,),
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

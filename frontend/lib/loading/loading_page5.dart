import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';

class loadingPage5 extends StatefulWidget {
  final UserData userData; 
  const loadingPage5(this.userData, {super.key}); 

  @override
  _LoadingPage5 createState() => _LoadingPage5();
}

class _LoadingPage5 extends State<loadingPage5> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double scrollStep = 3.0; // 스크롤 속도 조정

      if (currentScroll + scrollStep >= maxScroll) {
        _scrollController.jumpTo(0); // 끝에 도달하면 처음으로 돌아감
      } else {
        _scrollController.animateTo(
          currentScroll + scrollStep,
          duration: const Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${utf8.decode(widget.userData.name.runes.toList())} 님의\n루틴을 불러오고 있어요!',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30), // 텍스트와 컨테이너 간 거리
            Container(
              padding: const EdgeInsets.only(bottom: 50, top: 20), // 컨테이너 안 패딩
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  SizedBox(
                    height: 120, // 사진 크기
                    child: ListView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        const SizedBox(width: 70),
                        Image.asset('assets/BBI.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/emoji/apple.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/BBIpimple.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/emoji/lotion.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/BBImask.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/emoji/heart.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/BBIhappy.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/emoji/soap.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/BBIsad.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/emoji/icc.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/BBI.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/emoji/paint.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/BBI.png'),
                        const SizedBox(width: 70),
                        Image.asset('assets/emoji/apple.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 60), // 컨테이너와 버튼 간 거리
          ],
        ),
      ),
    );
  }
}

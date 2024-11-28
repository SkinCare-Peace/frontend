
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/face_detection/guidline.dart';

class LoadingPage0 extends StatefulWidget {
  @override
  _LoadingPage0 createState() => _LoadingPage0();
}

class _LoadingPage0 extends State<LoadingPage0> {
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
      double scrollStep = 3.0; // 스크롤 속도 조정하는거 

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
            const Text(
              '유지민 님의 피부 상태는\n몇점일까요?',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10), //몇점일까요에서 박스까지 거리
            Container(
              padding: const EdgeInsets.only( bottom: 50,  top: 20),  //컨테이너 안 패딩
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Column(
                children: [
                  const Text(
                    '유지민님의 피부 점수는 ?? 점',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,//글씨체 바꿔야할듯
                      color: Color.fromARGB(255, 106, 106, 106)
                    ),
                  ),
                  const SizedBox(height: 90),
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
            const SizedBox(height: 80), //컨테이너에서 버튼까지 거리
            ElevatedButton(
               onPressed: ()  => Navigator.push(context,
            MaterialPageRoute(
              builder: (context)=> const PicGuideline())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 20),

              ),
              child: const Text(
                '내 피부 상태 진단해보기',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

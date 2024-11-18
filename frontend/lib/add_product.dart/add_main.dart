import 'package:flutter/material.dart';
import 'add_byName.dart'; // SearchByName 파일을 import

class AddSkinCareMain extends StatelessWidget {
  const AddSkinCareMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 150),
              const Text(
                "현재 보유한\n스킨케어 제품이 있나요?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 90),
              // 첫 번째 TextField (검색어 입력 필드)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: TextField(
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    prefixIcon: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: "제품명으로 검색",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 246, 246),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 25, // 세로 크기 조정
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchByName(searchQuery: query), // 검색어 전달
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              // 두 번째 TextField
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: TextField(
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    prefixIcon: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        Icons.category,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    hintText: "카테고리 선택",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 150, 150, 150),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 246, 246, 246),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 25, 
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: const Text(
                    "내 보유 스킨케어",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 238, 237, 237),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  child: Text(
                    "건너뛰기",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "제품을 추가하면 루틴에 도움이 돼요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

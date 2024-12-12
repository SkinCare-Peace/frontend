import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:frontend/loading/loading_page1.dart';
import 'add_byName.dart';
import 'added_product.dart'; // AddedProduct import

class AddSkinCareMain extends StatefulWidget {
  final UserData userData;
  const AddSkinCareMain(this.userData, {super.key});

  @override
  State<AddSkinCareMain> createState() => _AddSkinCareMainState();
}

class _AddSkinCareMainState extends State<AddSkinCareMain> {
  List<Map<String, dynamic>> addedProducts = []; // 추가된 제품들용 리스트
  late TextEditingController _searchController; // 검색어 관리용 컨트롤러

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(); // 컨트롤러 초기화
  }

  @override
  void dispose() {
    _searchController.dispose(); //컨트롤러 해제
    super.dispose();
  }

  void _showCategoryPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 70,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "카테고리",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return GestureDetector(
                    onTap: () {
                      print('${category['name']} 선택됨');
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          category['icon']!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category['name']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: true, 
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView( // 전체 화면 스크롤
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 90),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: TextField(
                  controller: _searchController, // 컨트롤러 연결
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
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
                      vertical: 25,
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (query) {
                    if (query.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchByName(widget.userData,
                              searchQuery: query),
                        ),
                      ).then((result) {
                        if (result != null && result is List<Map<String, dynamic>>) {
                          setState(() {
                            addedProducts.addAll(result.where((product) {
                              return !addedProducts.any((existingProduct) =>
                                  existingProduct['name'] == product['name']);
                            }));
                          });
                        }
                        // 검색 후 검색창 비우기
                        _searchController.clear();
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: GestureDetector(
                  onTap: () {
                    _showCategoryPopup(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 246, 246, 246),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "카테고리 선택",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 150, 150, 150),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddedProduct(widget.userData),
                      ),
                    ).then((updatedProducts) {
                      if (updatedProducts != null) {
                        setState(() {
                          addedProducts = updatedProducts;
                        });
                      }
                    });
                  },
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LoadingPage1(widget.userData),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 238, 237, 237),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  child: Text(
                    "넘어가기",
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

// 카테고리 데이터
final List<Map<String, String>> _categories = [
  {'name': '토너', 'icon': 'assets/emoji/apple.png'},
  {'name': '선크림', 'icon': 'assets/BBI.png'},
  {'name': '크림', 'icon': 'assets/emoji/paint.png'},
  {'name': '세럼/에센스', 'icon': 'assets/emoji/lotion.png'},
  {'name': '앰플', 'icon': 'assets/emoji/soap.png'},
  {'name': '로션', 'icon': 'assets/emoji/heart.png'},
  {'name': '폼클렌징', 'icon': 'assets/emoji/icc.png'},
];

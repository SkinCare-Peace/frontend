// 제품명으로 검색하기 로직
import 'package:flutter/material.dart';
import 'added_product.dart';

class SearchByName extends StatefulWidget {
  final String searchQuery;

  const SearchByName({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> addedProducts = []; // 보유 제품 저장 리스트
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults(widget.searchQuery); // 초기 검색어 전달
  }

  Future<void> _fetchSearchResults(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 여기에 실제 백엔드 API 호출 로직 추가
      await Future.delayed(const Duration(seconds: 1)); // 모의 지연 시간
      final mockData = [
        {
          'name': '스킨푸드 캐롯 카로틴 카밍 워터패드',
          'image': 'https://via.placeholder.com/150',
          'volume': '60매',
        },
        {
          'name': '스킨푸드 데일리 마스크 30매',
          'image': 'https://via.placeholder.com/150',
          'volume': '30매',
        },
        {
          'name': '스킨푸드 캐롯 카로틴 릴리프 크림',
          'image': 'https://via.placeholder.com/150',
          'volume': '50ml',
        },
        {
          'name': '스킨푸드 캐롯 카로틴 모이스트 이펙터',
          'image': 'https://via.placeholder.com/150',
          'volume': '100ml',
        },
      ];

      _searchResults = mockData
          .where((item) => item['name']!.contains(query))
          .toList();
    } catch (e) {
      print('Error fetching search results: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// ***************************** 팝업 ***************************** // 
  void _showProductPopup(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left:45, right: 45, top: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 바
              Container(
              width: 70,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
              Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '용량 : ${product['volume']}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  product['image'],
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
               onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    addedProducts.add(product); // 보유 제품에 추가
                  });
                  print('${product['name']} 추가됨');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 87, 204, 222),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 55),
                ),
                child: const Text(
                  '보유 제품에 추가하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


// ***************************** 검색창 메인  ***************************** // 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 40.0, left: 10),
                      child: TextField(
                        controller: TextEditingController(text: widget.searchQuery),
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          hintText: "제품명을 검색하세요",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF6F6F6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                        ),
                        onSubmitted: (query) {
                          if (query.isNotEmpty) {
                            _fetchSearchResults(query);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //// ***************************** 검색 결과 표시 로직 ***************************** // 
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            "검색 결과가 없습니다.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final result = _searchResults[index];
                              return GestureDetector(
                                onTap: () {
                                  _showProductPopup(context, result);
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        result['image'],
                                        height: 170,
                                        width: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      result['name'],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 58, 58, 58),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

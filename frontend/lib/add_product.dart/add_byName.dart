import 'package:flutter/material.dart';

class SearchByName extends StatefulWidget {
  final String searchQuery;

  const SearchByName({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<SearchByName> createState() => _SearchByNameState();
}

class _SearchByNameState extends State<SearchByName> {
  List<Map<String, dynamic>> _searchResults = [];
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
        },
        {
          'name': '스킨푸드 데일리 마스크 30매',
          'image': 'https://via.placeholder.com/150',
        },
        {
          'name': '스킨푸드 캐롯 카로틴 릴리프 크림',
          'image': 'https://via.placeholder.com/150',
        },
        {
          'name': '스킨푸드 캐롯 카로틴 모이스트 이펙터',
          'image': 'https://via.placeholder.com/150',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 상단 검색창과 뒤로가기 버튼을 포함하는 패딩
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
                      padding: const EdgeInsets.only(right: 40.0, left: 10), // 검색창에만 패딩 적용
                      child: TextField(
                        controller: TextEditingController(text: widget.searchQuery),
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          hintText: "제품명을 검색하세요",
                          hintStyle: const TextStyle(
                            color: Colors.grey, // 힌트 텍스트 색상 회색으로 변경
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
            // 검색 결과 표시
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
                                  print('Selected: ${result['name']}');
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
                                        color: Color.fromARGB(255, 58, 58, 58)
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

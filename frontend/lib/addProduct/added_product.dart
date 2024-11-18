// 추가한 제품 보는 곳

import 'package:flutter/material.dart';

class AddedProduct extends StatefulWidget {
  final List<Map<String, dynamic>> products; // 보유 제품 리스트

  const AddedProduct({Key? key, required this.products}) : super(key: key);

  @override
  State<AddedProduct> createState() => _AddedProductState();
}

class _AddedProductState extends State<AddedProduct> {
  late List<Map<String, dynamic>> _productList; // 로컬 제품 리스트

  @override
  void initState() {
    super.initState();
    _productList = List.from(widget.products); // 초기 데이터 복사
  }

  void _removeProduct(int index) {
    setState(() {
      _productList.removeAt(index); // 제품 삭제
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "내 보유 스킨케어",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: _productList.isEmpty
          ? const Center(
              child: Text(
                "현재 등록된 상품이 없어요",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _productList.length,
                itemBuilder: (context, index) {
                  final product = _productList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 제품 이미지
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // 제품 이름
                        Expanded(
                          child: Text(
                            product['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // 삭제 버튼
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.grey,
                          ),
                          onPressed: () => _removeProduct(index), // 삭제 로직
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

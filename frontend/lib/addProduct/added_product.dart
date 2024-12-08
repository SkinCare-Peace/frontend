import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/user_data.dart';
import 'package:http/http.dart' as http;

class AddedProduct extends StatefulWidget {
  final UserData userData;

  const AddedProduct(this.userData, {super.key});

  @override
  State<AddedProduct> createState() => _AddedProductState();
}

class _AddedProductState extends State<AddedProduct> {
  List<Map<String, dynamic>> _productList = []; // 서버에서 가져올 화장품목록 저장룡
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProducts(); // 초기화시 -> 서버에서 제품 목록 가져오기
  }
 Future<void> _fetchUserProducts() async {
  setState(() {
    _isLoading = true;
  });

  try {
    // 사용자 보유 제품 ID 목록 가져오기
    final uri = Uri.parse("http://3.34.5.57/users/${widget.userData.id}/cosmetics");
    final response = await http.get(uri);

    if (response.statusCode == 200) {

      final List<dynamic> productIds = json.decode(utf8.decode(response.bodyBytes));
      print("API 응답 데이터: $productIds");

      // 제품 ID로 각각 요청을 보내서 상세 정보 가져오기 (생각해보니까 이거 필요함?)
      final List<Map<String, dynamic>> fetchedProducts = [];
      for (String productId in productIds) {
        final productDetails = await _fetchProductDetailsById(productId);
        if (productDetails != null) {
          fetchedProducts.add(productDetails);
        }
      }

      setState(() {
        _productList = fetchedProducts;
      });
    } else {
      print('Failed to fetch user products. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user products: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

// 제품 ID로 상세정보 가져오기(지워도 될수도?)
Future<Map<String, dynamic>?> _fetchProductDetailsById(String productId) async {
  try {
    final uri = Uri.parse("http://3.34.5.57/cosmetics/$productId");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decodedData = json.decode(utf8.decode(response.bodyBytes));
      print("제품 상세 데이터 ($productId): $decodedData");

      return {
        "_id": decodedData["_id"],
        "name": decodedData["name"],
        "brand": decodedData["brand"] ?? "알 수 없음",
        "image": decodedData["image_url"] ?? "https://via.placeholder.com/150",
        "volume": decodedData["volume"] ?? "알 수 없음",
        "selling_price": decodedData["selling_price"] ?? "가격 정보 없음",
      };
    } else {
      print('Failed to fetch product details for $productId. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching product details for $productId: $e');
  }
  return null;
}


  void _removeProduct(int index, String productId) async {
  try {
    final uri = Uri.parse("http://3.34.5.57/users/${widget.userData.id}/cosmetics/$productId");
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제품을 삭제했어요 :)")), 
      );
      print("제품 삭제함 : $productId");
      setState(() {
        _productList.removeAt(index);
      });
    } else {
      print("제품 삭제 실패 Status code: ${response.statusCode}");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("다시 삭제를 시도해보세요 :(")), 
      );
    print("제품 삭제 중 오류 발생: $e");
  }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _productList.isEmpty
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
                              onPressed: () => _removeProduct(index, product["_id"]),
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

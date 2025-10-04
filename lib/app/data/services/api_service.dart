import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modules/products/models/product_model.dart';

class ApiService {
  static const String _baseUrl = 'https://akbulut.com.tm/api/';

  Future<List<ProductModel>> getProducts() async {
    final List<ProductModel> allProducts = [];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      try {
        final response = await http.get(Uri.parse('${_baseUrl}products?page=$page'));

        if (response.statusCode == 200) {
          final dynamic responseData = json.decode(response.body);
          if (responseData is Map<String, dynamic>) {
            final List<dynamic> productData = responseData['data'];
            if (productData.isNotEmpty) {
              for (var item in productData) {
                try {
                  allProducts.add(ProductModel.fromJson(item as Map<String, dynamic>));
                } catch (e) {
                  print('Failed to parse item: $item');
                  print('Error: $e');
                }
              }
              page++;
            } else {
              hasMore = false;
            }
          } else if (responseData is List<dynamic>) {
            if (responseData.isNotEmpty) {
              for (var item in responseData) {
                try {
                  allProducts.add(ProductModel.fromJson(item as Map<String, dynamic>));
                } catch (e) {
                  print('Failed to parse item: $item');
                  print('Error: $e');
                }
              }
            }
            hasMore = false;
          } else {
            hasMore = false;
          }
        } else {
          // Stop if a page request fails.
          throw Exception('Failed to load products on page $page');
        }
      } catch (e) {
        // Re-throw the exception to be handled by the controller.
        throw Exception('Failed to load products: $e');
      }
    }
    return allProducts;
  }
}

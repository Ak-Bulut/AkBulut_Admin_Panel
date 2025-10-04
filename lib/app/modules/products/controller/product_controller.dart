import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/services/api_service.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var isGridView = false.obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  final productList = <ProductModel>[].obs;
  final filteredProductList = <ProductModel>[].obs;
  final ApiService _apiService = ApiService();
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      onSearchChanged(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      filteredProductList.assignAll(productList);
    } else {
      filteredProductList.assignAll(productList.where((product) => product.name.toLowerCase().contains(query.toLowerCase())));
    }
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      hasError(false);
      final products = await _apiService.getProducts();
      productList.assignAll(products);
      filteredProductList.assignAll(products);
    } catch (e) {
      hasError(true);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  void showProductDetails(ProductModel product) {
    Get.dialog(
      AlertDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (product.imageUrls.isNotEmpty) Image.network(product.imageUrls.first, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.image_not_supported)),
              const SizedBox(height: 16),
              Text('${'description'.tr}: ${product.description}'),
              const SizedBox(height: 8),
              Text('${'price'.tr}: \$${product.price.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('${'stock_left'.tr}: ${product.stockLeft}'),
              const SizedBox(height: 8),
              Text('${'stock_sold'.tr}: ${product.stockSold}'),
              const SizedBox(height: 8),
              Text('${'factory_of_origin'.tr}: ${product.factoryOfOrigin}'),
              const SizedBox(height: 8),
              Text('${'last_sale_destination'.tr}: ${product.lastSaleDestination}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }
}

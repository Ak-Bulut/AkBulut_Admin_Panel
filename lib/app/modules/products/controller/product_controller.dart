import 'package:akbulut_admin/app/data/services/category_service.dart';
import 'package:akbulut_admin/app/modules/products/models/category_model.dart';
import 'package:akbulut_admin/app/modules/products/views/products_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/data/services/api_service.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  // --- MEVCUT KODLARINIZ (DOKUNULMADI) ---
  var isGridView = false.obs;
  var isLoading = true.obs;
  var hasError = false.obs;

  final productList = <ProductModel>[].obs;
  final filteredProductList = <ProductModel>[].obs;
  final categoryList = <Category>[].obs;
  final selectedCategory = Rxn<Category>();

  final ApiService _apiService = ApiService();
  final CategoryService _categoryService = CategoryService();
  final TextEditingController searchController = TextEditingController();

  // --- YENİ EKLENEN KODLAR (ÜRÜN DETAY SAYFASI İÇİN GEREKLİ) ---

  // Detay sayfasında gösterilen/düzenlenen ürünü tutar
  final Rx<ProductModel?> currentProduct = Rx(null);

  // Düzenleme alanları için TextEditingController'lar
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController stockController;

  // Resim galerisi için seçili olan resmin URL'sini tutar
  var selectedImageUrl = ''.obs;
  var isSaving = false.obs;
  var isEditMode = false.obs;

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }

  void cancelEdit() {
    // Controller'ları ürünün mevcut verileriyle yeniden doldurarak değişiklikleri geri al
    if (currentProduct.value != null) {
      final product = currentProduct.value!;
      nameController.text = product.name;
      descriptionController.text = product.description;
      priceController.text = product.price.toString();
      stockController.text = product.stockLeft.toString();
    }
    isEditMode.value = false;
  }
  // --- YENİ EKLENEN KODLARIN SONU ---

  @override
  void onInit() {
    super.onInit();

    // Mevcut listener'ınız dokunulmadan kalıyor
    searchController.addListener(() {
      onSearchChanged(searchController.text);
    });

    // --- YENİ EKLENEN KODLAR (Controller'ları başlatmak için) ---
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    stockController = TextEditingController();
    // --- YENİ EKLENEN KODLARIN SONU ---
  }

  @override
  void onClose() {
    // Mevcut dispose'a ek olarak yenileri de dispose edelim
    searchController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.onClose();
  }

  // --- MEVCUT METOTLARINIZ (DOKUNULMADI) ---
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

  Future<void> fetchProducts({int? categoryId}) async {
    try {
      isLoading(true);
      hasError(false);
      final products = await _apiService.getProducts(categoryId: categoryId);
      productList.assignAll(products);
      filteredProductList.assignAll(products);
    } catch (e) {
      hasError(true);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      categoryList.assignAll(categories);
    } catch (e) {
      print(e);
    }
  }

  void selectCategory(Category? category) {
    selectedCategory.value = category;
    fetchProducts(categoryId: category?.id);
  }

  // --- YENİ EKLENEN METOTLAR (ÜRÜN DETAY SAYFASI İÇİN) ---

  /// Detay sayfasını açmadan önce verileri hazırlar ve sayfaya yönlendirir.
  void showProductDetailsDialog(ProductModel product) {
    // Seçili ürünü ayarla
    currentProduct.value = product;

    // TextEditingController'ları ürünün mevcut verileriyle doldur
    nameController.text = product.name;
    descriptionController.text = product.description;
    priceController.text = product.price.toString();
    stockController.text = product.stockLeft.toString();

    // Resim galerisi için ilk resmi seçili yap
    if (product.imageUrls.isNotEmpty) {
      selectedImageUrl.value = product.imageUrls.first;
    } else {
      selectedImageUrl.value = ''; // Resim yoksa boş bırak
    }

    // Yeni ProductDetailView dialogunu göster
    Get.dialog(const ProductDetailView());
  }

  /// Resim galerisindeki küçük resimlerden birine tıklandığında çağrılır
  void selectImage(String url) {
    selectedImageUrl.value = url;
  }

  /// Değişiklikleri Kaydet fonksiyonu
  Future<void> saveChanges() async {
    isSaving.value = true;
    try {
      // BURADA API'YE GÜNCELLEME İSTEĞİ GÖNDERİLİR
      print('Kaydediliyor...');
      await Future.delayed(const Duration(seconds: 2));

      Get.back(); // Bir önceki sayfaya dön
      Get.snackbar('Başarılı', 'Ürün bilgileri güncellendi.');
      // Değişikliklerin listede görünmesi için ürünleri yeniden çek
      fetchProducts(categoryId: selectedCategory.value?.id);
    } catch (e) {
      Get.snackbar('Hata', 'Ürün güncellenirken bir sorun oluştu.');
    } finally {
      isSaving.value = false;
    }
  }

  /// Ürünü Sil fonksiyonu
  void deleteProduct() {
    if (currentProduct.value == null) return;
    Get.defaultDialog(
      title: 'Ürünü Sil',
      middleText: 'Bu ürünü silmek istediğinizden emin misiniz?',
      onConfirm: () async {
        Get.back();
        print('Ürün siliniyor: ${currentProduct.value!.name}');
        // BURADA API'YE SİLME İSTEĞİ GÖNDERİLİR
        await Future.delayed(const Duration(seconds: 1));
        Get.back();
        Get.snackbar('Başarılı', '${currentProduct.value!.name} ürünü silindi.');
        fetchProducts(categoryId: selectedCategory.value?.id);
      },
    );
  }
}

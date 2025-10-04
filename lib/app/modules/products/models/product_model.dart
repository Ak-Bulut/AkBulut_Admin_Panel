class ProductModel {
  final List<String> imageUrls;
  final String name;
  final String sizes;
  final double price;
  final int stockLeft;
  final int stockSold;
  final String category;
  final double rating;
  final int reviewCount;
  final String factoryOfOrigin;
  final String lastSaleDestination;
  final String description;

  ProductModel({
    required this.imageUrls,
    required this.name,
    required this.sizes,
    required this.price,
    required this.stockLeft,
    required this.stockSold,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.factoryOfOrigin,
    required this.lastSaleDestination,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    try {
      final String baseUrl = 'https://akbulut.com.tm';
      final String? originalImagePath = json['photos'] != null ? json['photos']['original'] : null;
      final String fullImageUrl = originalImagePath != null && originalImagePath.startsWith('http') ? originalImagePath : '$baseUrl${originalImagePath ?? ''}';

      return ProductModel(
        imageUrls: originalImagePath != null ? [fullImageUrl] : [],
        name: json['name'] ?? 'No Name',
        sizes: 'N/A', // API does not provide sizes
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        stockLeft: (json['stock_left'] as int?) ?? 0,
        stockSold: (json['stock_sold'] as int?) ?? 0,
        category: json['category']?['name'] ?? 'Kategoriýa ýok',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: (json['review_count'] as int?) ?? 0,
        factoryOfOrigin: 'Default Factory', // API does not provide this info
        lastSaleDestination: 'Default Store', // API does not provide this info
        description: json['general_info'] ?? '',
      );
    } catch (e) {
      print('Error parsing product: $e');
      print('Problematic JSON: $json');
      return ProductModel(
        imageUrls: [],
        name: 'Parsing Error',
        sizes: '',
        price: 0,
        stockLeft: 0,
        stockSold: 0,
        category: '',
        rating: 0,
        reviewCount: 0,
        factoryOfOrigin: '',
        lastSaleDestination: '',
        description: 'Failed to parse product data.',
      );
    }
  }
}

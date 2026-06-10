class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String categoryId;
  final String imageUrl;
  final bool isAvailable;
  final bool isFeatured;
  final double? originalPrice;
  final String? badge;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.categoryId,
    required this.imageUrl,
    this.isAvailable = true,
    this.isFeatured = false,
    this.originalPrice,
    this.badge,
  });

  bool get isOnSale =>
      originalPrice != null && originalPrice! > price;

  double get discountPercent {
    if (!isOnSale) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }
}
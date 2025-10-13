class CartItemModel {
  final String title;
  final String brand;
  final double price;
  final int? quantity;
  final String imageUrl;

  CartItemModel({
    required this.title,
    required this.brand,
    required this.price,
    this.quantity,
    required this.imageUrl,
  });
}

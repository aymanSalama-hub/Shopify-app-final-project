class CartItemModel {
  final String id;
  final String title;
  final String brand;
  final double price;
  int? quantity;
  final String imageUrl;

  CartItemModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    this.quantity,
    required this.imageUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'brand': brand,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'],
      title: map['title'],
      brand: map['brand'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      imageUrl: map['imageUrl'],
    );
  }
}

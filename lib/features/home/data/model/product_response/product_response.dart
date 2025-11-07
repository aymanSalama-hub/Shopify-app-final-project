class ProductResponse {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;
  final Category category;

  ProductResponse({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      description: json['description'] ?? '',
      images: (json['images'] != null)
          ? List<String>.from(json['images'])
          : [],
      category: (json['category'] != null)
          ? Category.fromJson(json['category'])
          : Category.empty(),
    );
  }

  /// 🟣 نسخة فاضية من الكلاس (مفيدة في الـ Skeletonizer أو الـ loading)
  factory ProductResponse.empty() {
    return ProductResponse(
      id: 0,
      title: '',
      price: 0.0,
      description: '',
      images: [],
      category: Category.empty(),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  /// 🟣 نسخة فاضية من الكاتيجوري
  factory Category.empty() {
    return Category(id: 0, name: '', image: '');
  }
}

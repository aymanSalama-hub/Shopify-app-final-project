import 'package:bisky_shop/features/cart_order/data/model/model_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final List<CartItemModel> items;
  final double totalPrice;
  final String status;
  final String deliveryPrograss;
  final String address;
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.deliveryPrograss,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      // serialize items to plain maps so Firestore accepts them
      'items': items.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'deliveryPrograss': deliveryPrograss,
      'address': address,
      // Firestore expects a Timestamp for date fields
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final created = map['createdAt'];
    DateTime createdAt;
    if (created is Timestamp) {
      createdAt = created.toDate();
    } else if (created is DateTime) {
      createdAt = created;
    } else {
      createdAt = DateTime.now();
    }

    return OrderModel(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'active',
      deliveryPrograss: map['deliveryPrograss'] ?? '',
      address: map['address'] ?? '',
      createdAt: createdAt,
    );
  }

  /// Returns a copy of this OrderModel with updated fields
  OrderModel copyWith({
    String? orderId,
    String? userId,
    List<CartItemModel>? items,
    double? totalPrice,
    String? status,
    String? deliveryPrograss,
    String? address,
    DateTime? createdAt,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      deliveryPrograss: deliveryPrograss ?? this.deliveryPrograss,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

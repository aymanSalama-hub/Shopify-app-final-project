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
    return OrderModel(
      orderId: map['orderId'],
      userId: map['userId'],
      items:
          (map['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      totalPrice: (map['totalPrice'] as num).toDouble(),
      status: map['status'],
      deliveryPrograss: map['deliveryPrograss'],
      address: map['address'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

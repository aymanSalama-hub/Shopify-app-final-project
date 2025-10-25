import 'package:bisky_shop/features/cart_order/data/model/model_cart.dart';
import 'package:bisky_shop/features/cart_order/data/model/order_model.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardOrderCubit extends Cubit<CardOrderState> {
  CardOrderCubit() : super(CardOrderInitial());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var addressController = TextEditingController();
  var isPlacingOrder = false;
  var orderId1 = '';
  int tabIndex = 0;
  List<OrderModel> activeOrders = [];
  List<OrderModel> completedOrders = [];
  List<OrderModel> canceledOrders = [];

  Future<void> createOrder(
    List<CartItemModel> cartItems,
    double totalPrice,
  ) async {
    emit(CardOrderLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        // User must be logged in to create an order
        emit(CardOrderError('You must be logged in to place an order.'));
        return;
      }
      final userId = user.uid;
      final orderId = _firestore.collection('orders').doc().id;
      orderId1 = orderId;

      final order = OrderModel(
        orderId: orderId,
        userId: userId,
        items: cartItems,
        totalPrice: totalPrice,
        status: 'active',
        deliveryPrograss: 'Order Confirmed',
        address: '', // لسه المستخدم هيضيفه
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('orders')
          .doc(userId)
          .collection('Userorders')
          .doc(orderId)
          .set(order.toMap());
      emit(CardOrderLoaded());
    } catch (e) {
      print('Error creating order: $e');
      emit(CardOrderError(e.toString()));
    }
  }

  Future<void> updateOrderAddress(String orderId, String address) async {
    emit(CardOrderLoading());
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(_auth.currentUser!.uid)
          .collection('Userorders')
          .doc(orderId)
          .update({'address': address});
      emit(CardOrderLoaded());
    } catch (e) {
      emit(CardOrderError(e.toString()));
    }
  }

  Future<void> getAllUserOrders() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        // User must be logged in to create an order
        emit(CardOrderError('You must be logged in to place an order.'));
        return;
      }
      final userId = user.uid;
      final querySnapshot = await _firestore
          .collection('orders')
          .doc(userId)
          .collection('Userorders')
          .get();
      var orders = querySnapshot.docs.map((doc) {
        var order = OrderModel.fromMap(doc.data());

        return order;
      }).toList();
      activeOrders = orders.where((order) => order.status == 'active').toList();
      completedOrders = orders
          .where((order) => order.status == 'completed')
          .toList();
      canceledOrders = orders
          .where((order) => order.status == 'canceled')
          .toList();
      print(activeOrders.length);

      emit(CardOrderLoaded());
    } catch (e) {
      emit(CardOrderError(e.toString()));
    }
  }

  void increaseQuantity(CartItemModel item, int index) {
    item.quantity = (item.quantity ?? 0) + 1;
    emit(IncreaseQuantitySuccess());
  }

  /// Change the current orders tab and notify listeners
  void changeTabIndex(int index) {
    tabIndex = index;
    // Re-emit loaded so UI updates; preserve current data
    emit(CardOrderLoaded());
  }

  void decreaseQuantity(
    List<CartItemModel> cartItems,
    CartItemModel item,
    int index,
  ) {
    if ((item.quantity ?? 0) > 1) {
      item.quantity = (item.quantity ?? 0) - 1;
    } else {
      // Optional: remove item if quantity = 0
      cartItems.removeAt(index);
    }
    emit(IncreaseQuantitySuccess());
  }

  void removeItem(List<CartItemModel> cartItems, int index) {
    cartItems.removeAt(index);
    emit(IncreaseQuantitySuccess());
  }
}

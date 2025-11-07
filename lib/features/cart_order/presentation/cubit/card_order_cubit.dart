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
  var user1 = '';
  int tabIndex = 0;
  List<OrderModel> activeOrders = [];
  List<OrderModel> completedOrders = [];
  List<OrderModel> canceledOrders = [];
  OrderModel order = OrderModel(
    orderId: '',
    userId: '',
    items: [],
    totalPrice: 0,
    status: '',
    deliveryPrograss: '',
    address: '',
    createdAt: DateTime.now(),
  );

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
      final user = _auth.currentUser;
      if (user == null) {
        emit(CardOrderError('You must be logged in to update the order.'));
        return;
      }
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(user.uid)
          .collection('Userorders')
          .doc(orderId)
          .update({'address': address});
      emit(CardOrderLoaded());
    } catch (e) {
      emit(CardOrderError(e.toString()));
    }
  }

  Future<void> getorder(String orderId, String userId) async {
    emit(CardOrderLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(CardOrderError('You must be logged in to view the order.'));
        return;
      }
      final orderSnapshot = await _firestore
          .collection('orders')
          .doc(userId)
          .collection('Userorders')
          .doc(orderId)
          .get();
      if (orderSnapshot.exists) {
        order = OrderModel.fromMap(orderSnapshot.data()!);
        emit(CardOrderLoaded());
      } else {
        emit(CardOrderError('Order not found.'));
      }
    } catch (e) {
      emit(CardOrderError(e.toString()));
    }
  }

  Future<void> getAllUserOrders() async {
    emit(CardOrderLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        // User must be logged in to view orders
        emit(CardOrderError('You must be logged in to view orders.'));
        return;
      }
      // safe assign photoURL if available
      user1 = user.photoURL ?? '';
      if (user.photoURL != 'Admin') {
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
        activeOrders = orders
            .where((order) => order.status == 'active')
            .toList();
        completedOrders = orders
            .where((order) => order.status == 'completed')
            .toList();
        canceledOrders = orders
            .where((order) => order.status == 'canceled')
            .toList();
        emit(CardOrderLoaded());
      } else {
        print('Admin user detected, fetching all orders');
        List<OrderModel> allOrders = [];

        try {
          // For admin, directly query all Userorders using collectionGroup
          print('Querying all Userorders using collectionGroup');
          // Note: orderBy requires an index. Get orders without sorting first
          final ordersQuery = await _firestore
              .collectionGroup('Userorders')
              .get();

          print('Found ${ordersQuery.docs.length} total orders');

          // Convert each order document to OrderModel
          for (var doc in ordersQuery.docs) {
            try {
              final data = doc.data();
              // Get the user ID from the document path
              final pathParts = doc.reference.path.split('/');
              final userId =
                  pathParts[1]; // orders/{userId}/Userorders/{orderId}

              // Add essential fields if missing
              data['orderId'] = doc.id;
              data['userId'] = userId;

              print('Processing order ${doc.id} for user $userId');
              final order = OrderModel.fromMap(data);
              allOrders.add(order);
            } catch (e) {
              print('Error parsing order ${doc.id}: $e');
              print('Order data: ${doc.data()}');
            }
          }

          print('Total orders fetched: ${allOrders.length}');

          // Sort by date (newest first)
          allOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          // Filter into status lists
          activeOrders = allOrders
              .where((order) => order.status.toLowerCase() == 'active')
              .toList();
          completedOrders = allOrders
              .where((order) => order.status.toLowerCase() == 'completed')
              .toList();
          canceledOrders = allOrders
              .where((order) => order.status.toLowerCase() == 'canceled')
              .toList();

          print(
            'Active: ${activeOrders.length}, Completed: ${completedOrders.length}, Canceled: ${canceledOrders.length}',
          );
          emit(CardOrderLoaded());
          // Print first order details for debugging if available
          if (allOrders.isNotEmpty) {
            final first = allOrders.first;
            print(
              'Sample order - ID: ${first.orderId}, Status: ${first.status}, Items: ${first.items.length}',
            );
          }
        } catch (e) {
          print('Error fetching all orders: $e');
          emit(CardOrderError(e.toString()));
          return;
        }
      }

      print(activeOrders.length);

      emit(CardOrderLoaded());
    } catch (e) {
      emit(CardOrderError(e.toString()));
    }
  }

  Future<void> updatePrograss(
    String orderId,
    String prograss,
    String userId,
  ) async {
    try {
      emit(CardOrderLoading());
      final user = _auth.currentUser;
      if (user == null) {
        emit(CardOrderError('You must be logged in to update the order.'));
        return;
      }
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection('Userorders')
          .doc(orderId)
          .update({'deliveryPrograss': prograss});
      print(
        'Updated deliveryPrograss in Firestore for $orderId (user: $userId) -> $prograss',
      );
      // Update in-memory model so UI updates immediately
      try {
        if (order.orderId == orderId) {
          order = order.copyWith(deliveryPrograss: prograss);
          print(
            'Updated in-memory order deliveryPrograss to: ${order.deliveryPrograss}',
          );
        }
      } catch (e) {
        print('Error updating in-memory order: $e');
      }

      emit(CardOrderLoaded());
    } catch (e) {
      emit(CardOrderError(e.toString()));
    }
  }

  Future<void> completeOrder(String orderId, String userId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(CardOrderError('You must be logged in to complete the order.'));
        return;
      }
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(userId)
          .collection('Userorders')
          .doc(orderId)
          .update({'status': 'completed'});
      print(
        'Updated order status to completed in Firestore for $orderId (user: $userId)',
      );
      // Update in-memory model so UI updates immediately
      try {
        if (order.orderId == orderId) {
          order = order.copyWith(
            status: 'completed',
            deliveryPrograss: 'Delivered',
          );
          print(
            'Updated in-memory order status/deliveryPrograss: ${order.status}/${order.deliveryPrograss}',
          );
        }
      } catch (e) {
        print('Error updating in-memory order: $e');
      }

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

// ======= Provider for Tab Index =======
import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/features/cart_order/data/model/model_cart.dart';
import 'package:bisky_shop/features/cart_order/presentation/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final orderTabProvider = StateProvider<int>((ref) => 0);

List<CartItemModel> activeOrders = [
  CartItemModel(
    title: 'Airpods',
    brand: 'Apple',
    price: 333,
    quantity: 2,
    imageUrl: AppImages.product1,
  ),
  CartItemModel(
    title: 'Hoodie',
    brand: 'Puma',
    price: 50,
    quantity: 2,
    imageUrl: AppImages.product2,
  ),
];

List<CartItemModel> completedOrders = [
  CartItemModel(
    title: 'Watch',
    price: 40,
    brand: 'Rolex',
    imageUrl: AppImages.product,
  ),
];

List<CartItemModel> canceledOrders = [
  CartItemModel(
    title: 'Hoodie',
    price: 40,
    brand: 'Rolex',
    imageUrl: AppImages.product1,
  ),
];

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(orderTabProvider);

    final tabs = ['Active', 'Completed', 'Cancel'];

    // ===== Choose list based on tab =====
    List<CartItemModel> currentList = [];
    if (tabIndex == 0) {
      currentList = activeOrders;
    } else if (tabIndex == 1) {
      currentList = completedOrders;
    } else {
      currentList = canceledOrders;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: Color(0xfff2f2f2),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== Tabs =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(tabs.length, (index) {
                final isActive = index == tabIndex;
                return GestureDetector(
                  onTap: () =>
                      ref.read(orderTabProvider.notifier).state = index,
                  child: Column(
                    children: [
                      Text(
                        tabs[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isActive ? Colors.black : Colors.grey.shade500,
                        ),
                      ),
                      if (isActive)
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          height: 3,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          // ===== Orders List =====
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: currentList.isEmpty
                  ? const Center(
                      key: ValueKey('empty'),
                      child: Text(
                        'No orders found',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      key: ValueKey(tabIndex),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final order = currentList[index];
                        return OrderCard(order: order);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

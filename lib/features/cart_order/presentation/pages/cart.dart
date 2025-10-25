import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/features/cart_order/data/model/model_cart.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_cubit.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_state.dart';
import 'package:bisky_shop/features/cart_order/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final List<CartItemModel> cartItems = [
    CartItemModel(
      id: '',
      title: 'Watch',
      brand: 'Rolex',
      price: 40,
      quantity: 2,
      imageUrl: AppImages.product,
    ),
    CartItemModel(
      id: '',
      title: 'Airpods',
      brand: 'Apple',
      price: 333,
      quantity: 2,
      imageUrl: AppImages.product1,
    ),
    CartItemModel(
      id: '',
      title: 'Hoodie',
      brand: 'Puma',
      price: 50,
      quantity: 2,
      imageUrl: AppImages.product2,
    ),
  ];

  final double discount = 4.0;
  final double delivery = 2.0;

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity!));

  double get total => subtotal - discount + delivery;

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<CardOrderCubit>();
    return BlocConsumer<CardOrderCubit, CardOrderState>(
      buildWhen: (s, c) {
        return c is IncreaseQuantitySuccess;
      },
      listener: (context, state) {
        if (state is CardOrderLoading) {
          showdialog(context);
        } else if (state is CardOrderLoaded) {
          pop(context);
          pushTo(
            context,
            Routs.checkout,
            extra: {
              'orderId': cubit.orderId1,
              'totalItems': cartItems.length,
              'subtotal': subtotal,
              'discount': discount,
              'delivery': delivery,
              'total': total, // Add the total value
            },
          );
        } else if (state is CardOrderError) {
          pop(context);
          final msg = state.message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColorCart,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.whiteColor,
            title: const Text(
              'Cart',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: cartItems.isEmpty
              ? _buildEmptyCartState()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return CartItemWidget(
                            item: item,
                            onIncrease: () =>
                                cubit.increaseQuantity(item, index),
                            onDecrease: () =>
                                cubit.decreaseQuantity(cartItems, item, index),
                            onRemove: () => cubit.removeItem(cartItems, index),
                          );
                        },
                      ),
                    ),
                    _buildSummary(context, cubit),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSummary(BuildContext context, CardOrderCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          _buildSummaryRow(
            'Items',
            cartItems.isEmpty ? '0' : '${cartItems.length}',
          ),
          _buildSummaryRow(
            'Subtotal',
            cartItems.isEmpty ? '0' : '\$${subtotal.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Discount',
            cartItems.isEmpty ? '0' : '-\$${discount.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Delivery Charges',
            cartItems.isEmpty ? '0' : '\$${delivery.toStringAsFixed(2)}',
          ),
          const Divider(),
          _buildSummaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: 6),
          ElevatedButton(


            onPressed: cartItems.isEmpty
                ? null
                : () {
                    cubit.createOrder(cartItems, total);
                  },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Check Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildEmptyCartState() {
  return Expanded(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty cart illustration
            Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Color(0xFF6C63FF),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Looks like you haven\'t added any items to your cart yet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_cubit.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_state.dart';
import 'package:bisky_shop/features/cart_order/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final CardOrderCubit _cubit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cubit = CardOrderCubit()..watchCart();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CardOrderCubit, CardOrderState>(
        // No buildWhen: allow BlocConsumer to rebuild on all relevant cart/order states
        listener: (context, state) {
          var cubit = context.read<CardOrderCubit>();
          // show loading dialog on loading states
          if (state is CardOrderLoading || state is CardItemLoading) {
            if (!_isLoading) {
              _isLoading = true;
              showdialog(context);
            }
          }

          // when cart items loaded, ensure the widget rebuilds to show items
          if (state is CardItemLoaded) {
            if (_isLoading) {
              _isLoading = false;
              pop(context);
            }
            // force a rebuild in this StatefulWidget so UI updates immediately
            setState(() {});
          }

          // when order created, navigate to checkout
          if (state is CardOrderLoaded) {
            if (_isLoading) {
              _isLoading = false;
              pop(context);
            }
            pushTo(
              context,
              Routs.checkout,
              extra: {
                'orderId': cubit.orderId1,
                'totalItems': cubit.cartItems.length,
                'subtotal': cubit.subtotal,
                'discount': cubit.discount,
                'delivery': cubit.delivery,
                'total': cubit.total,
              },
            );
          }

          // show errors
          if (state is CardOrderError || state is CardItemError) {
            pop(context);
            final msg = state is CardOrderError
                ? state.message
                : (state as CardItemError).message;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        builder: (context, state) {
          var cubit = context.read<CardOrderCubit>();
          print(cubit.cartItems.length);

          // Handle specific cubit states explicitly so UI updates predictably

          if (state is CardItemError) {
            return Scaffold(body: Center(child: Text((state).message)));
          }

          if (state is CardOrderError) {
            return Scaffold(body: Center(child: Text((state).message)));
          }

          // Default: show cart content
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
            body: cubit.cartItems.isEmpty
                ? _buildEmptyCartState()
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cubit.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cubit.cartItems[index];
                            return CartItemWidget(
                              item: item,
                              onIncrease: () => cubit.increaseQuantity(item.id),
                              onDecrease: () => cubit.decreaseQuantity(item.id),
                              onRemove: () => cubit.removeItem(item.id),
                            );
                          },
                        ),
                      ),
                      _buildSummary(context, cubit),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CardOrderCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            cubit.cartItems.isEmpty ? '0' : '${cubit.cartItems.length}',
          ),
          _buildSummaryRow(
            'Subtotal',
            cubit.cartItems.isEmpty
                ? '0'
                : '\$${cubit.subtotal.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Discount',
            cubit.cartItems.isEmpty
                ? '0'
                : '-\$${cubit.discount.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Delivery Charges',
            cubit.cartItems.isEmpty
                ? '0'
                : '\$${cubit.delivery.toStringAsFixed(2)}',
          ),
          const Divider(),
          _buildSummaryRow(
            'Total',
            '\$${cubit.total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: 6),
          ElevatedButton(
            onPressed: cubit.cartItems.isEmpty
                ? null
                : () {
                    cubit.createOrder(cubit.cartItems, cubit.total);
                    cubit.removeAllItems();
                  },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              minimumSize: const Size(double.infinity, 55),
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
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
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
  );
}

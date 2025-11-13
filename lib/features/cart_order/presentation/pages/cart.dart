import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
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
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Dynamic colors based on theme
    final backgroundColor = theme.colorScheme.background;
    final appBarColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final primaryColor = theme.colorScheme.primary;
    final summaryCardColor = theme.colorScheme.surface;

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<CardOrderCubit, CardOrderState>(
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
                'totalItems': cubit.lengthitem,
                'subtotal': cubit.subtotaltrans,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = context.read<CardOrderCubit>();
          print(cubit.cartItems.length);

          // Handle specific cubit states explicitly so UI updates predictably
          if (state is CardItemError) {
            return Scaffold(
              backgroundColor: backgroundColor,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        (state).message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => cubit.watchCart(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is CardOrderError) {
            return Scaffold(
              backgroundColor: backgroundColor,
              body: Center(
                child: Text(
                  (state).message,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            );
          }

          // Default: show cart content
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              title: Text(
                'Cart',
                style: TextStyle(
                  color: textColor,
                  fontSize: isSmallScreen ? 24 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: cubit.cartItems.isEmpty
                ? _buildEmptyCartState(
                    theme,
                    primaryColor,
                    textColor,
                    subtitleColor,
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
                      _buildSummary(
                        context,
                        cubit,
                        summaryCardColor,
                        textColor,
                        subtitleColor,
                        primaryColor,
                        isSmallScreen,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildSummary(
    BuildContext context,
    CardOrderCubit cubit,
    Color summaryCardColor,
    Color textColor,
    Color subtitleColor,
    Color primaryColor,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: summaryCardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: isSmallScreen ? 15 : 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          _buildSummaryRow(
            'Items',
            cubit.cartItems.isEmpty ? '0' : '${cubit.cartItems.length}',
            textColor,
            subtitleColor,
          ),
          _buildSummaryRow(
            'Subtotal',
            cubit.cartItems.isEmpty
                ? '0'
                : '\$${cubit.subtotal.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
          ),
          _buildSummaryRow(
            'Discount',
            cubit.cartItems.isEmpty
                ? '0'
                : '-\$${cubit.discount.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
          ),
          _buildSummaryRow(
            'Delivery Charges',
            cubit.cartItems.isEmpty
                ? '0'
                : '\$${cubit.delivery.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
          ),
          Divider(color: subtitleColor.withOpacity(0.3)),
          _buildSummaryRow(
            'Total',
            '\$${cubit.total.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
            isBold: true,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          SizedBox(
            width: double.infinity,
            height: isSmallScreen ? 50 : 55,
            child: ElevatedButton(
              onPressed: cubit.cartItems.isEmpty
                  ? null
                  : () {
                      cubit.createOrder(cubit.cartItems, cubit.total);
                      cubit.removeAllItems();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              child: Text(
                'Check Out',
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String title,
    String value,
    Color textColor,
    Color subtitleColor, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
              color: isBold ? textColor : subtitleColor,
              fontSize: isBold ? 15 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? textColor : subtitleColor,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildEmptyCartState(
  ThemeData theme,
  Color primaryColor,
  Color textColor,
  Color subtitleColor,
) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: primaryColor.withOpacity(0.7),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Looks like you haven\'t added any items to your cart yet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: subtitleColor),
          ),
        ],
      ),
    ),
  );
}

// Helper function to show loading dialog
void showdialog(BuildContext context) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Processing...',
                style: TextStyle(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

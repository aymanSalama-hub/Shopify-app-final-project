import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_cubit.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.orderData});
  final Map<String, dynamic> orderData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Dynamic colors based on theme
    final backgroundColor = theme.colorScheme.background;
    final cardColor = theme.colorScheme.surface;
    final appBarColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);

    // Safely extract numeric values with fallbacks to avoid null arithmetic
    double subtotal = (orderData['subtotal'] as num?)?.toDouble() ?? 0.0;
    double discount = (orderData['discount'] as num?)?.toDouble() ?? 0.0;
    double delivery = (orderData['delivery'] as num?)?.toDouble() ?? 0.0;
    double total = (subtotal - discount + delivery);

    var cubit = context.read<CardOrderCubit>();

    return BlocListener<CardOrderCubit, CardOrderState>(
      listener: (context, state) {
        if (state is CardOrderLoading) {
          showdialog(context);
        } else if (state is CardOrderLoaded) {
          pop(context);
          pushTo(context, Routs.orderSuccess);
        } else if (state is CardOrderError) {
          pop(context);
          final msg = state.message;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: appBarColor,
          elevation: 0,
          title: Text(
            'Checkout',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 18 : 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 8 : 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Delivery Address', textColor),
              SizedBox(height: isSmallScreen ? 6 : 8),
              _buildAddressField(cubit, cardColor, textColor, subtitleColor),
              SizedBox(height: isSmallScreen ? 20 : 25),
              _buildSectionTitle('Order Summary', textColor),
              SizedBox(height: isSmallScreen ? 8 : 10),
              _buildSummaryBox(
                subtotal,
                discount,
                delivery,
                total,
                cardColor,
                textColor,
                subtitleColor,
                isSmallScreen,
              ),
              SizedBox(height: isSmallScreen ? 25 : 30),
              _buildPlaceOrderButton(cubit, theme, isSmallScreen, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: textColor,
      ),
    );
  }

  Widget _buildAddressField(
    CardOrderCubit cubit,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: cubit.addressController,
        maxLines: 3,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: 'Enter your full delivery address...',
          hintStyle: TextStyle(color: subtitleColor),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSummaryBox(
    double subtotal,
    double discount,
    double delivery,
    double total,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
    bool isSmallScreen,
  ) {
    final items = (orderData['totalItems'] as int?)?.toString() ?? '0';

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Items', items, textColor, subtitleColor),
          _buildSummaryRow(
            'Subtotal',
            '\$${subtotal.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
          ),
          _buildSummaryRow(
            'Discount',
            '-\$${discount.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
          ),
          _buildSummaryRow(
            'Delivery',
            '\$${delivery.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
          ),
          Divider(color: subtitleColor.withOpacity(0.3)),
          _buildSummaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            textColor,
            subtitleColor,
            bold: true,
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
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
              color: bold ? textColor : subtitleColor,
              fontSize: bold ? 15 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: bold ? textColor : subtitleColor,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(
    CardOrderCubit cubit,
    ThemeData theme,
    bool isSmallScreen,
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 50 : 55,
      child: ElevatedButton(
        onPressed: cubit.isPlacingOrder
            ? null
            : () => _placeOrder(cubit, theme, context),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 2,
        ),
        child: cubit.isPlacingOrder
            ? SizedBox(
                width: isSmallScreen ? 20 : 24,
                height: isSmallScreen ? 20 : 24,
                child: CircularProgressIndicator(
                  color: theme.colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Place Order',
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _placeOrder(
    CardOrderCubit cubit,
    ThemeData theme,
    BuildContext context,
  ) async {
    if (cubit.addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your delivery address',
            style: TextStyle(color: theme.colorScheme.onError),
          ),
          backgroundColor: theme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    cubit.isPlacingOrder = true;
    final orderId = orderData['orderId'] as String?;
    if (orderId != null) {
      cubit.updateOrderAddress(orderId, cubit.addressController.text);
    }

    cubit.isPlacingOrder = false;
  }
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
                'Placing Order...',
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

import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
<<<<<<< HEAD
<<<<<<< Updated upstream
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  bool _isPlacingOrder = false;

  // بيانات مؤقتة
  final int totalItems = 3;
  final double subtotal = 423;
  final double discount = 4;
  final double delivery = 2;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = subtotal - discount + delivery;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => pop(context),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Delivery Address'),
            const SizedBox(height: 8),
            _buildAddressField(),
            const SizedBox(height: 25),
            _buildSectionTitle('Order Summary'),
            const SizedBox(height: 10),
            _buildSummaryBox(total),
            const SizedBox(height: 30),
            _buildPlaceOrderButton(total),
          ],
=======
=======
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_cubit.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.orderData});
  final Map<String, dynamic> orderData;
  // بيانات مؤقتة

  @override
  Widget build(BuildContext context) {
    // Safely extract numeric values with fallbacks to avoid null arithmetic
    double subtotal = (orderData['subtotal'] as num?)?.toDouble() ?? 0.0;
    double discount = (orderData['discount'] as num?)?.toDouble() ?? 0.0;
    double delivery = (orderData['delivery'] as num?)?.toDouble() ?? 0.0;
    double total =
        (orderData['total'] as num?)?.toDouble() ??
        (subtotal - discount + delivery);

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
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Checkout',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => pop(context),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Delivery Address'),
              const SizedBox(height: 8),
              _buildAddressField(cubit),
              const SizedBox(height: 25),
              _buildSectionTitle('Order Summary'),
              const SizedBox(height: 10),
              _buildSummaryBox(subtotal, discount, delivery, total),
              const SizedBox(height: 30),
              _buildPlaceOrderButton(cubit),
            ],
          ),
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

<<<<<<< HEAD
<<<<<<< Updated upstream
  Widget _buildAddressField() {
=======
  Widget _buildAddressField(CardOrderCubit cubit) {
>>>>>>> Stashed changes
=======
  Widget _buildAddressField(CardOrderCubit cubit) {
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
<<<<<<< HEAD
<<<<<<< Updated upstream
        controller: _addressController,
=======
        controller: cubit.addressController,
>>>>>>> Stashed changes
=======
        controller: cubit.addressController,
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Enter your full delivery address...',
          border: InputBorder.none,
        ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< Updated upstream
  Widget _buildSummaryBox(double total) {
=======
=======
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
  Widget _buildSummaryBox(
    double subtotal,
    double discount,
    double delivery,
    double total,
  ) {
    final items = (orderData['totalItems'] as int?)?.toString() ?? '0';
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
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
<<<<<<< HEAD
<<<<<<< Updated upstream
          _buildSummaryRow('Items', '$totalItems'),
=======
          _buildSummaryRow('Items', items),
>>>>>>> Stashed changes
=======
          _buildSummaryRow('Items', items),
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow('Discount', '-\$${discount.toStringAsFixed(2)}'),
          _buildSummaryRow('Delivery', '\$${delivery.toStringAsFixed(2)}'),
          const Divider(),
          _buildSummaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< Updated upstream
  Widget _buildPlaceOrderButton(double total) {
=======
  Widget _buildPlaceOrderButton(CardOrderCubit cubit) {
>>>>>>> Stashed changes
=======
  Widget _buildPlaceOrderButton(CardOrderCubit cubit) {
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
<<<<<<< HEAD
<<<<<<< Updated upstream
        onPressed: _isPlacingOrder ? null : _placeOrder,
=======
        onPressed: cubit.isPlacingOrder ? null : () => _placeOrder(cubit),
>>>>>>> Stashed changes
=======
        onPressed: cubit.isPlacingOrder ? null : () => _placeOrder(cubit),
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
<<<<<<< HEAD
<<<<<<< Updated upstream
        child: _isPlacingOrder
=======
        child: cubit.isPlacingOrder
>>>>>>> Stashed changes
=======
        child: cubit.isPlacingOrder
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

<<<<<<< HEAD
<<<<<<< Updated upstream
  Future<void> _placeOrder() async {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your delivery address.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    // هنا المفروض تضيف الطلب في Firebase
    await Future.delayed(const Duration(seconds: 2)); // محاكاة عملية حفظ

    setState(() => _isPlacingOrder = false);

    if (mounted) {
      pushTo(context, Routs.orderSuccess);
    }
=======
=======
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
  Future<void> _placeOrder(CardOrderCubit cubit) async {
    
    if (cubit.addressController.text.trim().isEmpty) {
      return;
    }

    cubit.isPlacingOrder = true;
    final orderId = orderData['orderId'] as String?;
    if (orderId != null) {
      cubit.updateOrderAddress(orderId, cubit.addressController.text);
    }

    cubit.isPlacingOrder = false;
<<<<<<< HEAD
>>>>>>> Stashed changes
=======
>>>>>>> f76b9bdf127b917888a22e6c24bb603b568380ff
  }
}

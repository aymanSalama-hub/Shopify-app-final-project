// features/cart_order/presentation/widgets/order_card.dart
import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/features/cart_order/data/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final String? role;

  const OrderCard({super.key, required this.order, this.role});

  // Status color mapping
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'canceled':
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Status text based on tab
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'In Progress';
      case 'completed':
        return 'Delivered';
      case 'canceled':
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  // Get delivery date estimate
  String _getDeliveryDate() {
    final deliveryDate = order.createdAt.add(const Duration(days: 5));
    return 'Est. ${deliveryDate.day}/${deliveryDate.month}/${deliveryDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = order.items[0];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: [
          // ===== Order Header =====
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.orderId}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDeliveryDate(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(order.status),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getStatusText(order.status),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== Order Content =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ===== Product Image =====
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Image.asset(
                    firstItem.imageUrl.isNotEmpty
                        ? firstItem.imageUrl
                        : AppImages.product,
                    height: 90,
                    width: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 90,
                        width: 100,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.grey.shade400,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // ===== Order Info =====
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          firstItem.title,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          firstItem.brand,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        if (order.items.length > 1) ...[
                          const SizedBox(height: 2),
                          Text(
                            '+ ${order.items.length - 1} more items',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          '\$${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.deliveryPrograss,
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ===== Track Button =====
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      print('Role in OrderCard: $role');
                      if (role != 'Admin') {
                        pushTo(context, Routs.trackOrder, extra: order);
                      } else {
                        Map<String, dynamic> orderData = {
                          'orderId': order.orderId,
                          'userId': order.userId,
                        };

                        pushTo(context, Routs.adminTrack, extra: orderData);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Track',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

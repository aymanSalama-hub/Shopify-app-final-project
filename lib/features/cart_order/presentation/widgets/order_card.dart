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
    final theme = Theme.of(context);
    final firstItem = order.items[0];
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth < 600;

    // Dynamic colors based on theme
    final cardColor = theme.colorScheme.surface;
    final headerColor = theme.colorScheme.surfaceVariant;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final primaryColor = theme.colorScheme.primary;
    final borderColor = theme.colorScheme.outline.withOpacity(0.2);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        children: [
          // ===== Order Header =====
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSmallScreen ? 12 : 16),
                topRight: Radius.circular(isSmallScreen ? 12 : 16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderId}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isSmallScreen ? 14 : 16,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getDeliveryDate(),
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: isSmallScreen ? 10 : 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: isSmallScreen ? 4 : 6,
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
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== Order Content =====
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: isMediumScreen
                ? _buildMobileLayout(
                    context,
                    firstItem,
                    isSmallScreen,
                    theme,
                    textColor,
                    subtitleColor,
                    primaryColor,
                  )
                : _buildDesktopLayout(
                    context,
                    firstItem,
                    theme,
                    textColor,
                    subtitleColor,
                    primaryColor,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    dynamic firstItem,
    bool isSmallScreen,
    ThemeData theme,
    Color textColor,
    Color subtitleColor,
    Color primaryColor,
  ) {
    return Column(
      children: [
        // ===== Product Image and Info Row =====
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Product Image =====
            ClipRRect(
              borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
              child: Image.network(
                firstItem.imageUrl.isNotEmpty
                    ? firstItem.imageUrl
                    : AppImages.product,
                height: isSmallScreen ? 70 : 80,
                width: isSmallScreen ? 70 : 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: isSmallScreen ? 70 : 80,
                    width: isSmallScreen ? 70 : 80,
                    color: theme.colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: subtitleColor,
                      size: isSmallScreen ? 30 : 35,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),

            // ===== Order Info =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 14 : 16,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    firstItem.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: isSmallScreen ? 12 : 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    firstItem.brand,
                    style: TextStyle(
                      color: subtitleColor.withOpacity(0.8),
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                  ),
                  if (order.items.length > 1) ...[
                    SizedBox(height: 2),
                    Text(
                      '+ ${order.items.length - 1} more items',
                      style: TextStyle(
                        color: subtitleColor.withOpacity(0.6),
                        fontSize: isSmallScreen ? 9 : 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: isSmallScreen ? 8 : 12),

        // ===== Price, Status and Track Button Row =====
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${order.totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    order.deliveryPrograss,
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ===== Track Button =====
            SizedBox(
              width: isSmallScreen ? 80 : 100,
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
                  backgroundColor: primaryColor,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 6 : 8,
                  ),
                  elevation: 1,
                ),
                child: Text(
                  'Track',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    dynamic firstItem,
    ThemeData theme,
    Color textColor,
    Color subtitleColor,
    Color primaryColor,
  ) {
    return Row(
      children: [
        // ===== Product Image =====
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
          child: Image.network(
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
                color: theme.colorScheme.surfaceVariant,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: subtitleColor,
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  firstItem.title,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  firstItem.brand,
                  style: TextStyle(
                    color: subtitleColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                if (order.items.length > 1) ...[
                  const SizedBox(height: 2),
                  Text(
                    '+ ${order.items.length - 1} more items',
                    style: TextStyle(
                      color: subtitleColor.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  '\$${order.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: primaryColor,
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
              backgroundColor: primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              elevation: 1,
            ),
            child: Text(
              'Track',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:Shopify/features/cart_order/data/model/order_model.dart';
import 'package:flutter/material.dart';

class TrackOrderPage extends StatelessWidget {
  final OrderModel order;

  const TrackOrderPage({super.key, required this.order});

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

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
            size: isSmallScreen ? 20 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Track Order',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrderInfoCard(
                      order: order,
                      isSmallScreen: isSmallScreen,
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 20),
                    _OrderTimeline(
                      status: order.status,
                      deliveryPrograss: order.deliveryPrograss,
                      isSmallScreen: isSmallScreen,
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 20),
                    _AddressSection(
                      address: order.address,
                      isSmallScreen: isSmallScreen,
                      cardColor: cardColor,
                      textColor: textColor,
                      subtitleColor: subtitleColor,
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: isSmallScreen ? 20 : 30),
                      child: _ContactButton(
                        isSmallScreen: isSmallScreen,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  final OrderModel order;
  final bool isSmallScreen;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  const _OrderInfoCard({
    required this.order,
    required this.isSmallScreen,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row - Responsive layout
            isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Order #${order.orderId}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 16 : 18,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _buildStatusChip(order.status),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Order #${order.orderId}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 16 : 18,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusChip(order.status),
                    ],
                  ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            _buildInfoRow("Order Date:", _formatDate(order.createdAt)),
            _buildInfoRow("Items:", "${order.items.length} items"),
            _buildInfoRow("Delivery Progress:", order.deliveryPrograss),
            Divider(height: 24, color: subtitleColor.withOpacity(0.3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Total Amount:",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    "EGP ${order.totalPrice.toStringAsFixed(2)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final statusColor = _getStatusColor(status);

    return Container(
      constraints: BoxConstraints(minWidth: isSmallScreen ? 60 : 70),
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          status.toUpperCase(),
          maxLines: 1,
          style: TextStyle(
            color: statusColor,
            fontSize: isSmallScreen ? 10 : 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 3 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: subtitleColor,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  final String status;
  final String deliveryPrograss;
  final bool isSmallScreen;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  const _OrderTimeline({
    required this.status,
    required this.deliveryPrograss,
    required this.isSmallScreen,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
  });

  List<Map<String, dynamic>> get _steps {
    return [
      {
        "title": "Order Confirmed",
        "isDone": true,
        "description": "Your order has been confirmed",
      },
      {
        "title": "Order Processed",
        "isDone":
            status != 'canceled' &&
            (deliveryPrograss == 'Order Processed' ||
                deliveryPrograss == 'Out for Delivery' ||
                status == 'completed'),
        "description": "Items are being prepared for shipment",
      },
      {
        "title": "Out for Delivery",
        "isDone":
            deliveryPrograss == 'Out for Delivery' || status == 'completed',
        "description": "Your order is on the way",
      },
      {
        "title": status == 'canceled' ? "Order Cancelled" : "Delivered",
        "isDone": status == 'completed' || status == 'canceled',
        "description": status == 'canceled'
            ? "Order was cancelled"
            : "Your order has been delivered",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Timeline",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 16 : 18,
                color: textColor,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            ..._steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isLast = index == _steps.length - 1;
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: isSmallScreen ? 70 : 80),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: isSmallScreen ? 20 : 24,
                          height: isSmallScreen ? 20 : 24,
                          decoration: BoxDecoration(
                            color: step['isDone']
                                ? _getStatusColor(status)
                                : subtitleColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: step['isDone']
                                  ? _getStatusColor(status)
                                  : subtitleColor.withOpacity(0.4),
                              width: 2,
                            ),
                          ),
                          child: step['isDone']
                              ? Icon(
                                  Icons.check,
                                  size: isSmallScreen ? 12 : 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: isSmallScreen ? 50 : 60,
                            color: step['isDone']
                                ? _getStatusColor(status)
                                : subtitleColor.withOpacity(0.3),
                          ),
                      ],
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: isSmallScreen ? 16 : 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: step['isDone']
                                    ? textColor
                                    : subtitleColor,
                                fontWeight: step['isDone']
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              step['description'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 12,
                                color: subtitleColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  final String address;
  final bool isSmallScreen;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  const _AddressSection({
    required this.address,
    required this.isSmallScreen,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isSmallScreen ? 32 : 40,
              height: isSmallScreen ? 32 : 40,
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: theme.colorScheme.error,
                size: isSmallScreen ? 16 : 20,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Address",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    address,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: isSmallScreen ? 12 : 14,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    "Phone: +20 100 123 4567",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: subtitleColor,
                size: isSmallScreen ? 18 : 20,
              ),
              onPressed: () {
                _showEditAddressDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.surface,
        insetPadding: EdgeInsets.all(isSmallScreen ? 12 : 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth * 0.9,
            maxHeight: screenWidth * 0.8,
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Delivery Address",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(text: address),
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(color: theme.colorScheme.onBackground),
                    decoration: InputDecoration(
                      hintText: "Enter your delivery address",
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 8 : 12),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Address updated successfully",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(isSmallScreen ? 8 : 16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                        ),
                        child: Text(
                          "Save",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final bool isSmallScreen;
  final Color textColor;

  const _ContactButton({required this.isSmallScreen, required this.textColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: isSmallScreen ? double.infinity : null,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 24 : 32,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              onPressed: () {
                _showContactOptions(context);
              },
              icon: Icon(Icons.support_agent, size: isSmallScreen ? 18 : 20),
              label: Text(
                "Contact Support",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          TextButton(
            onPressed: () {
              // Call delivery person
            },
            child: Text(
              "Call Delivery Agent",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: isSmallScreen ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Contact Options",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                ..._buildContactListTiles(isSmallScreen, context, theme),
                SizedBox(height: isSmallScreen ? 8 : 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContactListTiles(
    bool isSmallScreen,
    BuildContext context,
    ThemeData theme,
  ) {
    return [
      ListTile(
        leading: Icon(
          Icons.phone,
          color: Colors.green,
          size: isSmallScreen ? 20 : 24,
        ),
        title: Text(
          "Call Support",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: theme.colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          "+20 100 123 4567",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          // Implement call functionality
        },
      ),
      ListTile(
        leading: Icon(
          Icons.chat,
          color: Colors.blue,
          size: isSmallScreen ? 20 : 24,
        ),
        title: Text(
          "Live Chat",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: theme.colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          "Chat with our support team",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          // Implement chat functionality
        },
      ),
      ListTile(
        leading: Icon(
          Icons.email,
          color: Colors.orange,
          size: isSmallScreen ? 20 : 24,
        ),
        title: Text(
          "Send Email",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: theme.colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          "support@biskyShop.com",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          // Implement email functionality
        },
      ),
    ];
  }
}

// Helper functions
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

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

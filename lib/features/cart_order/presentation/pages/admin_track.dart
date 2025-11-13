import 'package:bisky_shop/features/cart_order/data/model/order_model.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_cubit.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminTrackOrderPage extends StatefulWidget {
  const AdminTrackOrderPage({super.key, required this.orderdetails});
  final Map orderdetails;

  @override
  State<AdminTrackOrderPage> createState() => _AdminTrackOrderPageState();
}

class _AdminTrackOrderPageState extends State<AdminTrackOrderPage> {
  String get orderId1 => widget.orderdetails['orderId'];
  String get userId1 => widget.orderdetails['userId'];

  @override
  void initState() {
    super.initState();
    print('=== AdminTrackOrderPage InitState ===');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Post frame callback executing');
      final cubit = context.read<CardOrderCubit>();
      print('Cubit retrieved, calling getorder');
      cubit.getorder(
        widget.orderdetails['orderId'],
        widget.orderdetails['userId'],
      );
    });
  }

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

    CardOrderCubit cubit = context.read<CardOrderCubit>();

    return BlocConsumer<CardOrderCubit, CardOrderState>(
      listener: (context, state) {
        if (state is CardOrderLoaded) {
          setState(() {});
        }
        if (state is CardOrderError) {
          final msg = state.message;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      builder: (context, state) {
        if (state is CardOrderLoading) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
          );
        }

        if (cubit.order.orderId.isEmpty) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: Center(
              child: Text(
                "Loading order details...",
                style: TextStyle(color: textColor),
              ),
            ),
          );
        }

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
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrderInfoCard(
                  order: cubit.order,
                  isSmallScreen: isSmallScreen,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                ),
                SizedBox(height: isSmallScreen ? 12 : 20),
                _OrderTimeline(
                  order: cubit.order,
                  status: cubit.order.status,
                  deliveryPrograss: cubit.order.deliveryPrograss,
                  orderId1: orderId1,
                  userId1: userId1,
                  cubit: cubit,
                  isSmallScreen: isSmallScreen,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                ),
                SizedBox(height: isSmallScreen ? 12 : 20),
                _AddressSection(
                  address: cubit.order.address,
                  orderId: cubit.order.orderId,
                  userId: cubit.order.userId,
                  isSmallScreen: isSmallScreen,
                  cardColor: cardColor,
                  textColor: textColor,
                  subtitleColor: subtitleColor,
                ),
                SizedBox(height: isSmallScreen ? 20 : 30),
                _ContactButton(
                  isSmallScreen: isSmallScreen,
                  textColor: textColor,
                ),
              ],
            ),
          ),
        );
      },
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
            // Header - Responsive layout
            isSmallScreen
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${order.orderId}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildStatusChip(order.status, context),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      _buildStatusChip(order.status, context),
                    ],
                  ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            _buildInfoRow("Order Date:", _formatDate(order.createdAt)),
            _buildInfoRow("Items:", "${order.items.length} items"),
            _buildInfoRow("Delivery Progress:", order.deliveryPrograss),
            Divider(
              height: isSmallScreen ? 20 : 24,
              color: subtitleColor.withOpacity(0.3),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount:",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  "EGP ${order.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontSize: isSmallScreen ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 3 : 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  final OrderModel order;
  final String status;
  final String deliveryPrograss;
  final String orderId1;
  final String userId1;
  final CardOrderCubit cubit;
  final bool isSmallScreen;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  _OrderTimeline({
    required this.order,
    required this.status,
    required this.deliveryPrograss,
    required this.orderId1,
    required this.userId1,
    required this.cubit,
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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
              final showUpdateButton =
                  step['title'] != 'Order Confirmed' &&
                  order.status != 'completed' &&
                  step['title'] != order.deliveryPrograss;

              return Container(
                margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline indicator
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

                    // Step content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'],
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: step['isDone'] ? textColor : subtitleColor,
                              fontWeight: step['isDone']
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            step['description'],
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Update button
                    if (showUpdateButton) ...[
                      SizedBox(width: isSmallScreen ? 8 : 16),
                      SizedBox(
                        width: isSmallScreen ? 70 : 80,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              primaryColor,
                            ),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 8 : 12,
                                vertical: isSmallScreen ? 6 : 8,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (step['title'] == order.deliveryPrograss) {
                              return;
                            }

                            await cubit.updatePrograss(
                              order.orderId,
                              step['title'],
                              order.userId,
                            );

                            if (step['title'] == 'Delivered') {
                              await cubit.completeOrder(
                                order.orderId,
                                order.userId,
                              );
                            }

                            await cubit.getAllUserOrders();
                            await cubit.getorder(orderId1, userId1);
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontSize: isSmallScreen ? 10 : 12,
                            ),
                          ),
                        ),
                      ),
                    ],
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
  final String orderId;
  final String userId;
  final bool isSmallScreen;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;

  const _AddressSection({
    required this.address,
    required this.orderId,
    required this.userId,
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
    final controller = TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
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
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Expanded(
                  child: TextField(
                    controller: controller,
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
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(
                          "Cancel",
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
                        onPressed: () async {
                          final newAddress = controller.text.trim();
                          if (newAddress.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Address cannot be empty"),
                              ),
                            );
                            return;
                          }

                          try {
                            await FirebaseFirestore.instance
                                .collection('orders')
                                .doc(userId)
                                .collection('Userorders')
                                .doc(orderId)
                                .update({'address': newAddress});

                            try {
                              final cubit = BlocProvider.of<CardOrderCubit>(
                                context,
                              );
                              await cubit.getAllUserOrders();
                            } catch (_) {}

                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Address updated successfully"),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to update address: $e'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                        ),
                        child: Text(
                          "Save",
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
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 20),
                ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.green,
                    size: isSmallScreen ? 20 : 24,
                  ),
                  title: Text(
                    "Call Support",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  subtitle: Text(
                    "+20 100 123 4567",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
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
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  subtitle: Text(
                    "Chat with our support team",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
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
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  subtitle: Text(
                    "support@biskyShop.com",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
              ],
            ),
          ),
        ),
      ),
    );
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

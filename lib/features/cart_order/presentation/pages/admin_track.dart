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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (cubit.order.orderId.isEmpty) {
          return const Scaffold(
            body: Center(child: Text("Loading order details...")),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xfff7f7f7),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: isSmallScreen ? 20 : 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Track Order',
              style: TextStyle(
                color: Colors.black,
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
                ),
                SizedBox(height: isSmallScreen ? 12 : 20),
                _AddressSection(
                  address: cubit.order.address,
                  orderId: cubit.order.orderId,
                  userId: cubit.order.userId,
                  isSmallScreen: isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 20 : 30),
                _ContactButton(isSmallScreen: isSmallScreen),
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

  const _OrderInfoCard({required this.order, required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
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
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildStatusChip(order.status),
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
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      _buildStatusChip(order.status),
                    ],
                  ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            _buildInfoRow("Order Date:", _formatDate(order.createdAt)),
            _buildInfoRow("Items:", "${order.items.length} items"),
            _buildInfoRow("Delivery Progress:", order.deliveryPrograss),
            Divider(height: isSmallScreen ? 20 : 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Amount:",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "EGP ${order.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
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
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(status), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: _getStatusColor(status),
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
                color: Colors.grey.shade600,
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

  _OrderTimeline({
    required this.order,
    required this.status,
    required this.deliveryPrograss,
    required this.orderId1,
    required this.userId1,
    required this.cubit,
    required this.isSmallScreen,
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
      color: Colors.white,
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
                margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 1),
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
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: step['isDone']
                                  ? _getStatusColor(status)
                                  : Colors.grey.shade400,
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
                                : Colors.grey.shade300,
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
                              color: step['isDone']
                                  ? Colors.black
                                  : Colors.grey.shade600,
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
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Update button - Only show on mobile if there's space
                    if (showUpdateButton) ...[
                      SizedBox(width: isSmallScreen ? 8 : 16),
                      SizedBox(
                        width: isSmallScreen ? 70 : 80,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.deepPurple,
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
                              color: Colors.white,
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

  const _AddressSection({
    required this.address,
    required this.orderId,
    required this.userId,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
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
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.red.shade600,
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
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    address,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: isSmallScreen ? 12 : 14,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    "Phone: +20 100 123 4567",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isSmallScreen ? 10 : 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.grey.shade600,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final controller = TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
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
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: "Enter your delivery address",
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
                          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
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
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
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

  const _ContactButton({required this.isSmallScreen});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: isSmallScreen ? double.infinity : null,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
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
                color: Colors.deepPurple,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  ),
                  subtitle: Text(
                    "+20 100 123 4567",
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
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
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  ),
                  subtitle: Text(
                    "Chat with our support team",
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
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
                    style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  ),
                  subtitle: Text(
                    "support@biskyShop.com",
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
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

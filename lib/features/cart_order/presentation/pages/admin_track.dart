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
    CardOrderCubit cubit = context.read<CardOrderCubit>();

    return BlocBuilder<CardOrderCubit, CardOrderState>(
      builder: (context, state) {
        if (state is CardOrderLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is CardOrderError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        // Ensure order is loaded before displaying content
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
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Track Order',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OrderInfoCard(order: cubit.order),
                const SizedBox(height: 20),
                _OrderTimeline(
                  order: cubit.order,
                  status: cubit.order.status,
                  deliveryPrograss: cubit.order.deliveryPrograss,
                  orderId1: orderId1,
                  userId1: userId1,
                  cubit: cubit,
                ),
                const SizedBox(height: 20),
                _AddressSection(
                  address: cubit.order.address,
                  orderId: cubit.order.orderId,
                  userId: cubit.order.userId,
                ),
                const SizedBox(height: 30),
                _ContactButton(),
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

  const _OrderInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${order.orderId}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
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
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(order.status),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow("Order Date:", _formatDate(order.createdAt)),
            _buildInfoRow("Items:", "${order.items.length} items"),
            _buildInfoRow("Delivery Progress:", order.deliveryPrograss),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Amount:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "EGP ${order.totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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

  _OrderTimeline({
    required this.order,
    required this.status,
    required this.deliveryPrograss,
    required this.orderId1,
    required this.userId1,
    required this.cubit,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Timeline",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ..._steps.map((step) {
              final index = _steps.indexOf(step);
              final isLast = index == _steps.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
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
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 60,
                          color: step['isDone']
                              ? _getStatusColor(status)
                              : Colors.grey.shade300,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: TextStyle(
                            fontSize: 16,
                            color: step['isDone']
                                ? Colors.black
                                : Colors.grey.shade600,
                            fontWeight: step['isDone']
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  step['title'] != 'Order Confirmed' &&
                          order.status != 'completed'
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.deepPurple,
                            ),
                          ),
                          onPressed: () async {
                            if (step['title'] == order.deliveryPrograss) {
                              return;
                            }

                            // Update progress first
                            await cubit.updatePrograss(
                              order.orderId,
                              step['title'], // Use the target step's title
                              order.userId,
                            );

                            // If this is the last step (Delivered), complete the order
                            if (step['title'] == 'Delivered') {
                              await cubit.completeOrder(
                                order.orderId,
                                order.userId,
                              );
                            }

                            // Refresh data to update UI
                            await cubit.getAllUserOrders();
                            await cubit.getorder(orderId1, userId1);
                          },
                          child: Text(
                            'update',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : SizedBox(),
                ],
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

  const _AddressSection({
    required this.address,
    required this.orderId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.red.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Delivery Address",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Phone: +20 100 123 4567",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey.shade600, size: 20),
              onPressed: () {
                // Edit address functionality
                _showEditAddressDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context) {
    final controller = TextEditingController(text: address);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Edit Delivery Address"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: "Enter your delivery address",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAddress = controller.text.trim();
              if (newAddress.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Address cannot be empty")),
                );
                return;
              }

              // Call cubit to update address; catch errors and show feedback
              try {
                // Update address directly in Firestore for the specified user/order
                await FirebaseFirestore.instance
                    .collection('orders')
                    .doc(userId)
                    .collection('Userorders')
                    .doc(orderId)
                    .update({'address': newAddress});

                // Optionally refresh cubit data if available
                try {
                  final cubit = BlocProvider.of<CardOrderCubit>(context);
                  await cubit.getAllUserOrders();
                } catch (_) {}

                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Address updated successfully")),
                );
              } catch (e) {
                // Keep dialog open and show error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update address: $e')),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            onPressed: () {
              _showContactOptions(context);
            },
            icon: const Icon(Icons.support_agent, size: 20),
            label: const Text(
              "Contact Support",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // Call delivery person
            },
            child: Text(
              "Call Delivery Agent",
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Contact Options",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text("Call Support"),
              subtitle: const Text("+20 100 123 4567"),
              onTap: () {
                Navigator.pop(context);
                // Implement call functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.blue),
              title: const Text("Live Chat"),
              subtitle: const Text("Chat with our support team"),
              onTap: () {
                Navigator.pop(context);
                // Implement chat functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.orange),
              title: const Text("Send Email"),
              subtitle: const Text("support@biskyShop.com"),
              onTap: () {
                Navigator.pop(context);
                // Implement email functionality
              },
            ),
          ],
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

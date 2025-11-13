// Orders screen rewritten: TabBar + TabBarView with Bloc-driven data

import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_cubit.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_state.dart';
import 'package:bisky_shop/features/cart_order/presentation/widgets/order_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Ensure orders are loaded when the screen appears
    // Use addPostFrameCallback to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CardOrderCubit>();
      cubit.getAllUserOrders();
      // keep cubit.tabIndex in sync with tab controller
      _tabController.index = cubit.tabIndex;
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) return;
        // Update tab index and refresh data from Firebase
        cubit.changeTabIndex(_tabController.index);
        cubit.getAllUserOrders(); // Refresh data when tab changes
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _emptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabs = const ['Active', 'Completed', 'Cancelled'];
    final cubit = context.read<CardOrderCubit>();

    // Dynamic colors based on theme
    final backgroundColor = theme.colorScheme.background;
    final appBarColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: cubit.user1 == 'Admin'
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 12),
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: textColor),
                  ),
                ),
              ),
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: cubit.user1 == 'Admin'
            ? [
                // Sign Out Button in AppBar
                IconButton(
                  icon: Icon(Icons.logout, color: theme.colorScheme.error),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    pushAndRemoveUntil(context, Routs.login);
                  },
                  tooltip: 'Sign Out',
                ),
              ]
            : null,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: textColor,
          unselectedLabelColor: subtitleColor,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      backgroundColor: backgroundColor,
      body: BlocBuilder<CardOrderCubit, CardOrderState>(
        builder: (context, state) {
          if (state is CardOrderLoading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (state is CardOrderError) {
            final msg = state.message;
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (msg.toLowerCase().contains('logged in')) {
                          pushTo(context, Routs.login);
                        } else {
                          context.read<CardOrderCubit>().getAllUserOrders();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      child: Text(
                        msg.toLowerCase().contains('logged in')
                            ? 'Login'
                            : 'Retry',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Loaded or initial: show TabBarView mapped to cubit's lists
          return TabBarView(
            controller: _tabController,
            children: [
              // Active
              Builder(
                builder: (context) {
                  final list = cubit.activeOrders;
                  if (list.isEmpty) return _emptyState(theme);
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        OrderCard(order: list[index], role: cubit.user1),
                  );
                },
              ),
              // Completed
              Builder(
                builder: (context) {
                  final list = cubit.completedOrders;
                  if (list.isEmpty) return _emptyState(theme);
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        OrderCard(order: list[index], role: cubit.user1),
                  );
                },
              ),
              // Cancelled
              Builder(
                builder: (context) {
                  final list = cubit.canceledOrders;
                  if (list.isEmpty) return _emptyState(theme);
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        OrderCard(order: list[index], role: cubit.user1),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

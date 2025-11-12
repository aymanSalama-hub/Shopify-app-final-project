import 'package:bisky_shop/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bisky_shop/features/auth/presentation/page/login.dart';
import 'package:bisky_shop/features/auth/presentation/page/register.dart';
import 'package:bisky_shop/features/cart_order/data/model/order_model.dart';
import 'package:bisky_shop/features/cart_order/presentation/cubit/card_order_cubit.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/admin_track.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/cart.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/order_success_screen.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/orders.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/place_order.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/track_order.dart';
import 'package:bisky_shop/features/details/presentation/cubit/addCart_cubit.dart';
import 'package:bisky_shop/features/details/presentation/pages/product_details.dart';
import 'package:bisky_shop/features/home/data/model/product_response/product_response.dart';
import 'package:bisky_shop/features/main/main_app_navigation.dart';
import 'package:bisky_shop/features/person/presentation/cubit/profile_cubit.dart';
import 'package:bisky_shop/features/person/presentation/pages/person_screen.dart';
import 'package:bisky_shop/features/person/presentation/pages/section_profile.dart';
import 'package:bisky_shop/features/person/presentation/pages/settings_screen.dart';
import 'package:bisky_shop/features/products/presentation/pages/product_gride_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/on_boarding/presentation/pages/onboarding_body.dart';
import '../../features/splash/splash_screen.dart';

class Routs {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainAppNavigation = '/mainAppNavigation';
  static const String products = '/products';
  static const String details = '/details';
  static const String cart = '/cart';
  static const String order = '/order';
  static const String trackOrder = '/trackOrder';
  static const String person = '/person';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/orderSuccess';
  static const String adminTrack = '/adminTrack';
  static const String profile = '/profile';

  static final routes = GoRouter(
    initialLocation: Routs.splash,
    routes: [
      GoRoute(
        path: mainAppNavigation,
        builder: (context, state) => BlocProvider(
          create: (context) => CardOrderCubit(),
          child: MainAppNavigationScreen(name: (state.extra as String?) ?? ''),
        ),
      ),

      GoRoute(
        path: products,
        builder: (context, state) => ProductGrideScreen(),
      ),

      GoRoute(
        path: details,
        builder: (context, state) => BlocProvider(
          create: (context) => AddcartCubit(),
          child: ProductDetailsScreen(product: state.extra as ProductResponse3),
        ),
      ),

      GoRoute(path: cart, builder: (context, state) => CartScreen()),

      GoRoute(
        path: checkout,
        builder: (context, state) => BlocProvider(
          create: (context) => CardOrderCubit(),
          child: CheckoutScreen(orderData: state.extra as Map<String, dynamic>),
        ),
      ),

      GoRoute(
        path: orderSuccess,
        builder: (context, state) => OrderSuccessScreen(),
      ),

      GoRoute(
        path: order,
        builder: (context, state) => BlocProvider(
          create: (context) => CardOrderCubit()..getAllUserOrders(),
          child: OrdersScreen(),
        ),
      ),
      GoRoute(
        path: adminTrack,
        builder: (context, state) => BlocProvider(
          create: (context) => CardOrderCubit(),

          child: AdminTrackOrderPage(orderdetails: state.extra as Map),
        ),
      ),

      GoRoute(
        path: trackOrder,
        builder: (context, state) =>
            TrackOrderPage(order: state.extra as OrderModel),
      ),

      GoRoute(
        path: login,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: LoginScreen(),
        ),
      ),

      GoRoute(
        path: register,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: RegisterScreen(),
        ),
      ),

      GoRoute(
        path: splash,
        builder: (context, state) => ProviderScope(child: SplashBody()),
      ),

      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileCubit()..loadUserData(),
          child: const ProfileScreen(),
        ),
      ),

      GoRoute(
        path: person,
        builder: (context, state) => BlocProvider(
          create: (context) => ProfileCubit()..loadUserData(),
          child: const PersonScreen(),
        ),
      ),

      GoRoute(path: onboarding, builder: (context, state) => OnBoarding_body()),
    ],
  );
}

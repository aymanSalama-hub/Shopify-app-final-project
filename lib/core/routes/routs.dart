import 'package:bisky_shop/features/auth/presentation/page/login.dart';
import 'package:bisky_shop/features/auth/presentation/page/register.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/cart.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/orders.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/track_order.dart';
import 'package:bisky_shop/features/main/main_app_navigation.dart';
import 'package:bisky_shop/features/person/presentation/pages/person_screen.dart';
import 'package:bisky_shop/features/person/presentation/pages/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/on_boarding/presentation/pages/onboarding_body.dart';
import '../../features/splash/splash_screen.dart';

class Routs {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainAppNavigation = '/mainAppNavigation';
  static const String home = '/home';
  static const String details = '/details';
  static const String cart = '/cart';
  static const String order = '/order';
  static const String trackOrder = '/trackOrder';
  static const String person = '/person';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';

  static final routes = GoRouter(
    initialLocation: Routs.splash,
    routes: [
      GoRoute(
        path: mainAppNavigation,
        builder: (context, state) => MainAppNavigationScreen(),
      ),
      GoRoute(path: cart, builder: (context, state) => CartScreen()),
      GoRoute(
        path: order,
        builder: (context, state) => ProviderScope(child: OrdersScreen()),
      ),
      GoRoute(path: trackOrder, builder: (context, state) => TrackOrderPage()),
      GoRoute(path: login, builder: (context, state) => LoginScreen()),
      GoRoute(path: register, builder: (context, state) => RegisterScreen()),
      //GoRoute(path: home, builder: (context, state) => HomeScreen()),

      //Mohamed Work //
      // GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(path: person, builder: (context, state) => const PersonScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: splash,
        builder: (context, state) => ProviderScope(child: SplashBody()),
      ),
      GoRoute(path: onboarding, builder: (context, state) => OnBoarding_body()),

    ],
  );
}

import 'package:bisky_shop/features/home/presentation/pages/home_screen.dart';
import 'package:bisky_shop/features/main/main_app_navigation.dart';
import 'package:go_router/go_router.dart';

class Routs {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainAppNavigation = '/mainAppNavigation';
  static const String home = '/home';
  static const String details = '/details';

  static final routes = GoRouter(
    initialLocation:mainAppNavigation ,
    routes: [
      // GoRoute(path: splash, builder: (context, state) => SplashScreen()),
      GoRoute(
        path: mainAppNavigation,
        builder: (context, state) => MainAppNavigationScreen(),
      ),
      //GoRoute(path: home, builder: (context, state) => HomeScreen()),

      //Mohamed Work //
      // GoRoute(path: '/', builder: (context, state) => const HomePage()),
      // GoRoute(
      //   path: '/person',
      //   builder: (context, state) => const PersonScreen(),
      // ),
      // GoRoute(
      //   path: '/settings',
      //   builder: (context, state) => const SettingsScreen(),
      // ),
    ],
  );
}

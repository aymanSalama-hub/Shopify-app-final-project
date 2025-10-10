import 'package:bisky_shop/ui/home_page.dart';
import 'package:bisky_shop/ui/person_screen.dart';
import 'package:bisky_shop/ui/settings_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/person', builder: (context, state) => const PersonScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

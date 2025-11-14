import 'package:Shopify/core/constants/app_images.dart';
import 'package:Shopify/core/utils/app_colors.dart';
import 'package:Shopify/features/cart_order/presentation/pages/cart.dart';
import 'package:Shopify/features/favorite/presentation/pages/favorite_screen.dart';
import 'package:Shopify/features/home/presentation/pages/home_screen.dart';
import 'package:Shopify/features/person/presentation/cubit/profile_cubit.dart';
import 'package:Shopify/features/person/presentation/pages/person_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../favorite/presentation/cubit/favourite_cubit.dart';

class MainAppNavigationScreen extends StatefulWidget {
  const MainAppNavigationScreen({super.key, required this.name});
  final String name;

  @override
  State<MainAppNavigationScreen> createState() =>
      _MainAppNavigationScreenState();
}

class _MainAppNavigationScreenState extends State<MainAppNavigationScreen> {
  int selectedIndex = 0;

  late List<Widget> pages;
  @override
  void initState() {
    super.initState();
    pages = [
      HomeScreen(name: widget.name),
      BlocProvider<FavoritesCubit>(
        create: (_) => FavoritesCubit()..loadFavorites(),
        child: const FavoritesScreen(),
      ),
      CartScreen(),
      // Provide ProfileCubit for the PersonScreen when used inside the main tabs
      BlocProvider(
        create: (_) => ProfileCubit()..loadUserData(),
        child: const PersonScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          btmNavBarItem(path: AppImages.homeSvg, label: 'Home'),
          btmNavBarItem(icon: Icons.favorite, label: ' Favorite'),
          btmNavBarItem(path: AppImages.lockSvg, label: 'Lock'),
          btmNavBarItem(path: AppImages.profileSvg, label: 'Profile'),
        ],
      ),
    );
  }

  BottomNavigationBarItem btmNavBarItem({
    String? path,
    required String label,
    IconData? icon,
  }) {
    return BottomNavigationBarItem(
      activeIcon: path != null
          ? SvgPicture.asset(
              width: 24,
              height: 24,
              path,
              colorFilter: ColorFilter.mode(
                AppColors.primayColor,
                BlendMode.srcIn,
              ),
            )
          : Icon(
              icon!,
              color: AppColors.primayColor,
              blendMode: BlendMode.srcIn,
            ),
      icon: path != null
          ? SvgPicture.asset(
              path,
              width: 24,
              height: 24,

              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            )
          : Icon(icon!, color: Colors.grey, blendMode: BlendMode.srcIn),
      label: label,
    );
  }
}

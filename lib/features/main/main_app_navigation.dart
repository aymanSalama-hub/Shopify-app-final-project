import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/features/cart_order/presentation/pages/cart.dart';
import 'package:bisky_shop/features/favorite/favorite_screen.dart';
import 'package:bisky_shop/features/home/presentation/pages/home_screen.dart';
import 'package:bisky_shop/features/person/presentation/pages/person_screen.dart';
import 'package:bisky_shop/features/person/presentation/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
      FavoriteScreen(),
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
          btmNavBarItem(path: AppImages.searchSvg, label: ' Favorite'),
          btmNavBarItem(path: AppImages.lockSvg, label: 'Lock'),
          btmNavBarItem(path: AppImages.profileSvg, label: 'Profile'),
        ],
      ),
    );
  }

  BottomNavigationBarItem btmNavBarItem({
    required String path,
    required String label,
  }) {
    return BottomNavigationBarItem(
      activeIcon: SvgPicture.asset(
        width: 24,
        height: 24,
        path,
        colorFilter: ColorFilter.mode(AppColors.primayColor, BlendMode.srcIn),
      ),
      icon: SvgPicture.asset(
        path,
        width: 24,
        height: 24,

        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
      ),
      label: label,
    );
  }
}

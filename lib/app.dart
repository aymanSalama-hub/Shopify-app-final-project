import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routs.routes,
      debugShowCheckedModeBanner: false,
      title: 'Bisky Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: AppColors.backgroundColor,

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundColor,
          selectedItemColor: AppColors.primayColor,
          unselectedItemColor: AppColors.grayColor,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}

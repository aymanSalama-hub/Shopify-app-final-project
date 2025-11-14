import 'package:Shopify/core/routes/routs.dart';
import 'package:Shopify/core/services/theme_service.dart';
import 'package:Shopify/features/person/presentation/cubit/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  const MyApp({super.key, required this.themeService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(themeService),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          ThemeMode themeMode = ThemeMode.system;

          if (state is ThemeLoaded) {
            switch (state.theme) {
              case 'light':
                themeMode = ThemeMode.light;
                break;
              case 'dark':
                themeMode = ThemeMode.dark;
                break;
              case 'system':
              default:
                themeMode = ThemeMode.system;
            }
          }

          return MaterialApp.router(
            routerConfig: Routs.routes,
            debugShowCheckedModeBanner: false,
            title: 'Bisky Shop',
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: themeMode,
            // theme: ThemeData(
            //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            //   scaffoldBackgroundColor: AppColors.backgroundColor,
            //   appBarTheme: AppBarTheme(
            //     backgroundColor: Colors.white,
            //     elevation: 0,
            //     shadowColor: Colors.transparent,
            //     surfaceTintColor: Colors.white,
            //   ),
            //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
            //     backgroundColor: AppColors.backgroundColor,
            //     selectedItemColor: AppColors.primayColor,
            //     unselectedItemColor: AppColors.grayColor,
            //     type: BottomNavigationBarType.fixed,
            //     showSelectedLabels: false,
            //     showUnselectedLabels: false,
            //   ),
            // ),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.deepPurple,
      colorScheme: ColorScheme.light(
        primary: Colors.deepPurple,
        secondary: Colors.orange,
        background: Colors.white,
        surface: Colors.white,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      // Add more light theme customizations
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple[300],
      colorScheme: ColorScheme.dark(
        primary: Colors.deepPurple[300]!,
        secondary: Colors.orange[300]!,
        background: Colors.grey[900]!,
        surface: Colors.grey[800]!,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      cardTheme: CardThemeData(
        color: Colors.grey[800],
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.deepPurple[300],
        unselectedItemColor: Colors.grey[400],
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      // Add more dark theme customizations
    );
  }
}

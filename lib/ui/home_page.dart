import 'package:bisky_shop/cubit/bottom_nav_cubit.dart';
import 'package:bisky_shop/widget/custom_text_field_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomTextFieldButton(
          text: 'اكتب هنا',
          icon: Icons.edit,
          onTap: () {
            // ضع هنا ما يحدث عند الضغط
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<BottomNavCubit, int>(
        builder: (context, index) {
          return BottomNavigationBar(
            currentIndex: index,
            onTap: (selectedIndex) {
              context.read<BottomNavCubit>().setIndex(selectedIndex);
              if (selectedIndex == 3) {
                context.go('/person');
              }
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Person',
              ),
            ],
          );
        },
      ),
    );
  }
}

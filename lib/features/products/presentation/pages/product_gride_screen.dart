import 'package:bisky_shop/core/constants/app_constants.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/utils/text_styles.dart';
import 'package:bisky_shop/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductGrideScreen extends StatelessWidget {
  const ProductGrideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        'title': 'Watch',
        'price': '\$40',
        'image':
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Watch for fashion lovers.',
      },
      {
        'title': 'Nike Shoes',
        'price': '\$430',
        'image':
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=764',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Nike Shoes for sports enthusiasts.',
      },
      {
        'title': 'Airpods',
        'price': '\$333',
        'image':
            'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Airpods for music lovers.',
      },
      {
        'title': 'Blover',
        'price': '\$300',
        'image':
            'https://images.unsplash.com/photo-1562157873-818bc0726f68?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2127',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Blover for fashion lovers.',
      },
      {
        'title': 'TSHirt',
        'price': '\$500',
        'image':
            'https://images.unsplash.com/photo-1523381294911-8d3cead13475?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality TShirt for fashion lovers.',
      },
      {
        'title': 'LG TV',
        'price': '\$330',
        'image':
            'https://images.unsplash.com/photo-1717295248230-93ea71f48f92?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1228',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality LG TV for home entertainment.',
      },
      {
        'title': 'LG TV',
        'price': '\$330',
        'image':
            'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality LG TV for home entertainment.',
      },
      {
        'title': 'Hoodie',
        'price': '\$50',
        'image':
            'https://images.unsplash.com/photo-1615397587950-3cbb55f95b77?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Hoodie for casual wear.',
      },
      {
        'title': 'Jacket',
        'price': '\$400',
        'image':
            'https://images.unsplash.com/photo-1619603364904-c0498317e145?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Jacket for winter season.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.blackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(AppStrings.products),
        titleTextStyle: TextStyles.styleSize16.copyWith(
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: AppConstants.badding16,
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            // childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            var item = products[index];
            return GestureDetector(
              onTap: () {
                pushTo(context, Routs.details, extra: item);
              },
              child: ProductCard(item: item),
            );
          },
        ),
      ),
    );
  }
}

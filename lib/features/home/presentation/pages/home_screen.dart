import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/utils/text_styles.dart';
import 'package:bisky_shop/features/home/presentation/widgets/home_slider.dart';
import 'package:bisky_shop/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.name});
  String name;

  final List<Map<String, String>> featured = [
    {
      'title': 'Watch',
      'price': '\$40',
      'image':
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800',
    },
    {
      'title': 'Nike Shoes',
      'price': '\$430',
      'image':
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=764',
    },
    {
      'title': 'Airpods',
      'price': '\$333',
      'image':
          'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    },
  ];

  final List<Map<String, String>> popular = [
    {
      'title': 'LG TV',
      'price': '\$330',
      'image':
          'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=800',
    },
    {
      'title': 'Hoodie',
      'price': '\$50',
      'image':
          'https://images.unsplash.com/photo-1615397587950-3cbb55f95b77?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=687',
    },
    {
      'title': 'Jacket',
      'price': '\$400',
      'image':
          'https://images.unsplash.com/photo-1606112219348-204d7d8b94ee?w=800',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1521334884684-d80222895322?auto=format&fit=crop&w=80&q=80',
              ),
            ),
            Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello!", style: TextStyles.styleSize12),
                Gap(5),
                Text(name, style: TextStyles.styleSize14),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(AppImages.notificationSvg),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(24),
                HomeSlider(),
                Gap(12),
                Text(
                  AppStrings.featured,
                  style: TextStyles.styleSize18.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(12),

                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: featured.length,
                    separatorBuilder: (context, index) {
                      return const Gap(16);
                    },
                    itemBuilder: (context, index) {
                      final item = featured[index];
                      return ProductCard(item: item);
                    },
                  ),
                ),
                Gap(24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      AppStrings.mostPopular,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppStrings.seeAll,
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ],
                ),

                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: popular.length,
                    separatorBuilder: (context, index) => const Gap(16),
                    itemBuilder: (context, index) {
                      final item = popular[index];
                      return ProductCard(item: item);
                    },
                  ),
                ),
                const Gap(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

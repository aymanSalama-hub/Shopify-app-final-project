import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  item['image'] ?? 'https://via.placeholder.com/150',
                  height: 110,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const Positioned(
                right: 8,
                top: 8,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? "NoData",
                  style: TextStyles.styleSize14.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Gap(4),
                Text(
                  item['price'] ?? "NoData",
                  style: TextStyles.styleSize12.copyWith(
                    color: AppColors.primayColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} //class

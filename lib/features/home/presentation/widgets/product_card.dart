import 'package:bisky_shop/core/constants/size_responsive.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductCard extends StatelessWidget {
  final dynamic item;

  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // نعبّي بيانات Sizeresponsive
    Sizeresponsive().init(context);
    final ds = Sizeresponsive.defaultSize!;
    final sw = Sizeresponsive.screenWidth!;

    return Container(
      width: sw * 0.4, // حوالي 40% من عرض الشاشة
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ds * 2), // ≈16px
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: ds * 0.5, // ≈4px
            offset: Offset(0, ds * 0.25), // ≈2px
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصورة تاخد جزء كبير من الكارت
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(ds * 2)),
              child: Image.network(
                item.images[0],
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // باقي التفاصيل
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(ds * 0.5), // ≈8px
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ds * 1.5, // ≈12px
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(ds * 0.5), // ≈4px
                  Text(
                    "\$${item.price}",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: ds * 1.5, // ≈12px
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

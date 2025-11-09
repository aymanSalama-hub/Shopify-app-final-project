import 'package:bisky_shop/core/constants/size_responsive.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProductCard extends StatelessWidget {
  final dynamic item;

  const ProductCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Sizeresponsive().init(context);
    final ds = Sizeresponsive.defaultSize!;
    final sw = Sizeresponsive.screenWidth!;

    return Container(
      width: sw * 0.4,
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
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(ds * 2)),
              child: Image.network(
                (item?.image is String && item.image!.isNotEmpty)
                    ? item.image!
                    : "https://picsum.photos/200",
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/notfound.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(ds * 0.5), // ≈8px
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "No Data",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ds * 1.5, // ≈12px
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(ds * 0.5), // ≈4px
                  Text(
                    "\$${item.price ?? 0}",
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

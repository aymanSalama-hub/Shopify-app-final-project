import 'package:bisky_shop/core/constants/app_constants.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/utils/text_styles.dart';
import 'package:bisky_shop/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/size_responsive.dart';

class ProductGrideScreen extends StatefulWidget {
  const ProductGrideScreen({super.key});

  @override
  State<ProductGrideScreen> createState() => _ProductGrideScreenState();
}

class _ProductGrideScreenState extends State<ProductGrideScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?auto=format&fit=crop&q=80&w=764',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Nike Shoes for sports enthusiasts.',
      },
      {
        'title': 'Airpods',
        'price': '\$333',
        'image':
        'https://images.unsplash.com/photo-1610438235354-a6ae5528385c?auto=format&fit=crop&q=80&w=687',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Airpods for music lovers.',
      },
      {
        'title': 'Blover',
        'price': '\$300',
        'image':
        'https://images.unsplash.com/photo-1562157873-818bc0726f68?auto=format&fit=crop&q=80&w=2127',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Blover for fashion lovers.',
      },
      {
        'title': 'TSHirt',
        'price': '\$500',
        'image':
        'https://images.unsplash.com/photo-1523381294911-8d3cead13475?auto=format&fit=crop&q=80&w=1170',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality TShirt for fashion lovers.',
      },
      {
        'title': 'LG TV',
        'price': '\$330',
        'image':
        'https://images.unsplash.com/photo-1717295248230-93ea71f48f92?auto=format&fit=crop&q=80&w=1228',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality LG TV for home entertainment.',
      },
      {
        'title': 'Hoodie',
        'price': '\$50',
        'image':
        'https://images.unsplash.com/photo-1615397587950-3cbb55f95b77?auto=format&fit=crop&q=80&w=687',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Hoodie for casual wear.',
      },
      {
        'title': 'Jacket',
        'price': '\$400',
        'image':
        'https://images.unsplash.com/photo-1619603364904-c0498317e145?auto=format&fit=crop&q=80&w=687',
        'rating': 4.3,
        'reviews': 12,
        'description': 'High quality Jacket for winter season.',
      },
    ];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: Sizeresponsive.defaultSize! * 6,
          bottom: Sizeresponsive.defaultSize! * 0.2,
          left: Sizeresponsive.defaultSize! * 1.6,
          right: Sizeresponsive.defaultSize! * 1.6,
        ),
        child: Column(
          children: [
            // 🔍 Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Search product...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() {});
                      },
                      child: const Icon(Icons.cancel, color: Colors.black),
                    ),
                ],
              ),
            ),

            SizedBox(height: Sizeresponsive.defaultSize! * 1),

            // 🟣 Results Row
            if (_controller.text.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results for "${_controller.text}"',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '6 Results Found',
                    style: const TextStyle(
                      color: Color(0xFF6055D8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            SizedBox(height: Sizeresponsive.defaultSize! * 1),

            // 🛍️ GridView
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.9,
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
          ],
        ),
      ),
    );
  }
}

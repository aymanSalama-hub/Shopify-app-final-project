import 'package:Shopify/core/routes/navigation.dart';
import 'package:Shopify/core/routes/routs.dart';
import 'package:Shopify/features/home/presentation/cubit/home_cubit.dart';
import 'package:Shopify/features/home/presentation/cubit/home_state.dart';
import 'package:Shopify/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/size_responsive.dart';

class ProductGrideScreen extends StatefulWidget {
  const ProductGrideScreen({super.key});

  @override
  State<ProductGrideScreen> createState() => _ProductGrideScreenState();
}

class _ProductGrideScreenState extends State<ProductGrideScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // عدد الأعمدة حسب عرض الشاشة
    int crossAxisCount;
    if (screenWidth >= 1000) {
      crossAxisCount = 4;
    } else if (screenWidth >= 700) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return BlocProvider(
      create: (context) => HomeCubit()..fechHomeData(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // محتوى الصفحة: GridView
            Padding(
              padding: EdgeInsets.only(
                top: Sizeresponsive.defaultSize! * 6,
                bottom: Sizeresponsive.defaultSize! * 0.2,
                left: Sizeresponsive.defaultSize! * 1.6,
                right: Sizeresponsive.defaultSize! * 1.6,
              ),
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final cubit = context.read<HomeCubit>();

                  if (state is LoadingHomeSTate) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }

                  if (state is ErrorHomeState) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: Sizeresponsive.defaultSize! * 2,
                        ),
                      ),
                    );
                  }

                  if (cubit.productList3 == null ||
                      cubit.productList3!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: Sizeresponsive.defaultSize! * 8,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          SizedBox(height: Sizeresponsive.defaultSize! * 2),
                          Text(
                            "No products available",
                            style: TextStyle(
                              fontSize: Sizeresponsive.defaultSize! * 2,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: Sizeresponsive.defaultSize! * 1),
                          Text(
                            "Check back later for new products",
                            style: TextStyle(
                              fontSize: Sizeresponsive.defaultSize! * 1.6,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: cubit.productList3!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: Sizeresponsive.defaultSize! * 2,
                      crossAxisSpacing: Sizeresponsive.defaultSize! * 2,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      var product = cubit.productList3![index];
                      return GestureDetector(
                        onTap: () {
                          pushTo(context, Routs.details, extra: product);
                        },
                        child: ProductCard(item: product),
                      );
                    },
                  );
                },
              ),
            ),

            // App Bar مع Stack
            Container(
              height:
                  kToolbarHeight +
                  MediaQuery.of(context).padding.top +
                  Sizeresponsive.defaultSize! * 2,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: Sizeresponsive.defaultSize! * 2,
                right: Sizeresponsive.defaultSize! * 2,
              ),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).appBarTheme.backgroundColor ??
                    (isDarkMode
                        ? Colors.black.withOpacity(0.8)
                        : Colors.white.withOpacity(0.9)),
                boxShadow: [
                  if (isDarkMode)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    )
                  else
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: Sizeresponsive.defaultSize! * 3,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Products",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: Sizeresponsive.defaultSize! * 2.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: Sizeresponsive.defaultSize! * 6),
                    ],
                  ),
                  SizedBox(height: Sizeresponsive.defaultSize! * 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:Shopify/core/constants/app_images.dart';
import 'package:Shopify/core/constants/app_strings.dart';
import 'package:Shopify/core/constants/size_responsive.dart';
import 'package:Shopify/core/routes/navigation.dart';
import 'package:Shopify/core/routes/routs.dart';
import 'package:Shopify/core/utils/app_colors.dart';
import 'package:Shopify/core/utils/text_styles.dart';
import 'package:Shopify/features/home/presentation/cubit/home_cubit.dart';
import 'package:Shopify/features/home/presentation/cubit/home_state.dart';
import 'package:Shopify/features/home/presentation/widgets/home_slider.dart';
import 'package:Shopify/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../notification/presentation/pages/notification_page.dart';
import '../widgets/product_search_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.name});
  static const String routeName = '/homeScreen';
  String name;

  @override
  Widget build(BuildContext context) {
    Sizeresponsive().init(context);

    final sw = Sizeresponsive.screenWidth!;
    final sh = Sizeresponsive.screenHeight!;
    final ds = Sizeresponsive.defaultSize!;

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => HomeCubit()..fechHomeData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          var cubit = context.read<HomeCubit>();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: Row(
                children: [
                  CircleAvatar(
                    radius: ds * 2.2,
                    backgroundImage: (() {
                      final String url = cubit.photoUrl;
                      if (url.isEmpty) {
                        return const NetworkImage(
                          'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-File.png',
                        );
                      }
                      if (url.startsWith('http')) {
                        return NetworkImage(url) as ImageProvider<Object>;
                      }
                      return FileImage(File(url)) as ImageProvider<Object>;
                    })(),
                  ),
                  Gap(ds * 1.1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello!",
                        style: TextStyles.styleSize12.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Gap(ds * 0.5),
                      Text(
                        cubit.name == '' ? name : cubit.name,
                        style: TextStyles.styleSize14.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsPage(),
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    AppImages.notificationSvg,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            body: SafeArea(
              child: RefreshIndicator(
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                onRefresh: () async {
                  await cubit.fechHomeData();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      ds * 2.1,
                      ds * 2.1,
                      ds * 2.1,
                      ds * 0.5,
                    ),
                    child: Skeletonizer(
                      enabled: state is! SuccessHomeState,
                      effect: ShimmerEffect(
                        baseColor: isDarkMode
                            ? Colors.grey[800]!
                            : AppColors.backgroundColorCart,
                        highlightColor: isDarkMode
                            ? Colors.grey[600]!
                            : AppColors.lightGrayColor.withValues(alpha: .6),
                        duration: const Duration(seconds: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProductSearchScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[800]!
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                                border: isDarkMode
                                    ? Border.all(color: Colors.grey[700]!)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Discover your Product...",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: ds * 1),
                          Gap(ds * 2.4),
                          HomeSlider(sliderList: cubit.sliderProducts),
                          Gap(ds * 1.2),
                          Text(
                            AppStrings.featured,
                            style: TextStyles.styleSize18.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                          Gap(ds * 1.2),
                          // featured
                          SizedBox(
                            height: ds * 20,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              separatorBuilder: (context, index) =>
                                  Gap(ds * 1.6),
                              itemBuilder: (context, index) {
                                final product = cubit.featuredList5![index];
                                return GestureDetector(
                                  onTap: () {
                                    pushTo(
                                      context,
                                      Routs.details,
                                      extra: product,
                                    );
                                  },
                                  child: ProductCard(item: product!),
                                );
                              },
                            ),
                          ),

                          Gap(ds * 2.6),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.mostPopular,
                                style: TextStyle(
                                  fontSize: ds * 1.8,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onBackground,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  pushTo(context, Routs.products);
                                },
                                child: Text(
                                  AppStrings.seeAll,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontSize: ds * 1.4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(ds * 2.0),
                          // most popular
                          SizedBox(
                            height: ds * 20,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              separatorBuilder: (context, index) =>
                                  Gap(ds * 1.6),
                              itemBuilder: (context, index) {
                                final item = cubit.mostPopularTop5![index];
                                return GestureDetector(
                                  onTap: () {
                                    pushTo(context, Routs.details, extra: item);
                                  },
                                  child: ProductCard(item: item!),
                                );
                              },
                            ),
                          ),
                          Gap(ds * 3.2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

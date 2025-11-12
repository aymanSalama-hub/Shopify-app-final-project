import 'dart:io';

import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/constants/size_responsive.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/utils/text_styles.dart';
import 'package:bisky_shop/features/home/presentation/cubit/home_cubit.dart';
import 'package:bisky_shop/features/home/presentation/cubit/home_state.dart';
import 'package:bisky_shop/features/home/presentation/widgets/home_slider.dart';
import 'package:bisky_shop/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../widgets/product_search_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.name});
  String name;

  @override
  Widget build(BuildContext context) {
    Sizeresponsive().init(context);

    final sw = Sizeresponsive.screenWidth!;
    final sh = Sizeresponsive.screenHeight!;
    final ds = Sizeresponsive.defaultSize!;

    return BlocProvider(
      create: (context) => HomeCubit()..fechHomeData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          var cubit = context.read<HomeCubit>();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
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
                      Text("Hello!", style: TextStyles.styleSize12),
                      Gap(ds * 0.5),
                      Text(
                        name == '' ? cubit.name : name,
                        style: TextStyles.styleSize14,
                      ),
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
              child: RefreshIndicator(
                color: AppColors.primayColor,
                backgroundColor: Colors.white,
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
                        baseColor: AppColors.backgroundColorCart,
                        highlightColor: AppColors.lightGrayColor.withValues(
                          alpha: .6,
                        ),
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
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.search, color: Colors.grey[600]),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Discover your Product...",
                                    style: TextStyle(
                                      color: Colors.grey[600],
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
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  pushTo(context, Routs.products);
                                },
                                child: Text(
                                  AppStrings.seeAll,
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: ds * 1.4,
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

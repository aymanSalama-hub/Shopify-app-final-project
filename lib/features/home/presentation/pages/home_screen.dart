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

    // اختصار للقيم اللي هنستخدمها كتير
    final sw = Sizeresponsive.screenWidth!;
    final sh = Sizeresponsive.screenHeight!;
    final ds = Sizeresponsive.defaultSize!;

    return BlocProvider(
      create: (context) => HomeCubit()..fechHomeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              CircleAvatar(
                // 9.6 * 20/10
                radius: ds * 2.2,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1521334884684-d80222895322?auto=format&fit=crop&w=80&q=80',
                ),
              ),
              Gap(ds * 1.1), //10
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello!", style: TextStyles.styleSize12),
                  Gap(ds * 0.5),
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

        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            var cubit = context.read<HomeCubit>();

            // if (state is SuccessHomeState) {
            return SafeArea(
              child: SingleChildScrollView(
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
                      duration: Duration(seconds: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProductSearchScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Sizeresponsive.defaultSize! * 1),
                        Gap(ds * 2.4), // ≈ 24px
                        HomeSlider(sliderList: cubit.sliderProducts),
                        Gap(ds * 1.2), // ≈ 12px
                        Text(
                          AppStrings.featured,
                          style: TextStyles.styleSize18.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(ds * 1.2), // ≈ 12px

                        SizedBox(
                          height: ds * 20, // ≈ 190px   (9.6* (200/100) )
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (context, index) {
                              return Gap(ds * 1.6);
                            },
                            itemBuilder: (context, index) {
                              final product = cubit.productList![index];
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

                        Gap(ds * 2.4), // ≈ 24px
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.mostPopular,
                              style: TextStyle(
                                fontSize: ds * 1.8, // ≈ 18px
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
                                ), // ≈ 14px),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: ds * 20, // ≈ 190px
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (context, index) =>
                                Gap(ds * 1.6), // ≈ 16px,
                            itemBuilder: (context, index) {
                              final item = cubit.productList![index];
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
            );
            // } //else if (state is ErrorHomeState) {
            //   return Center(child: Text(state.message));
            // } else if (state is LoadingHomeSTate) {
            //   return Center(child: CircularProgressIndicator());
            // } else {
            //   return Center(child: Text("Loading"));
            // }
          },
        ),
      ),
    );
  }
}

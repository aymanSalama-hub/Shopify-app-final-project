import 'package:bisky_shop/core/constants/size_responsive.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/features/home/data/model/product_response/product_response.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key, required this.sliderList});

  final List<ProductResponse?>? sliderList;

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 1) تهيئة Sizeresponsive
    Sizeresponsive().init(context);
    final ds = Sizeresponsive.defaultSize!;
    final sh = Sizeresponsive.screenHeight!;
    final sw = Sizeresponsive.screenWidth!;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.sliderList!.length,
          itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(ds), // نسبي للحجم
              child: Image.network(
                widget.sliderList![itemIndex]!.images.isNotEmpty
                    ? widget.sliderList![itemIndex]!.images[0]
                    : "https://picsum.photos/200",
                width: double.infinity,
                height: sh * 0.25, // 25% من ارتفاع الشاشة
                fit: BoxFit.cover,
              ),
            );
          },
          options: CarouselOptions(
            height: sh * 0.25, // نفس ارتفاع الصورة
            viewportFraction: 1,
            initialPage: activeIndex,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            onPageChanged: (index, reason) {
              setState(() {
                activeIndex = index;
              });
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        Gap(ds * 1.5), // مسافة مرنة
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: widget.sliderList!.length,
          axisDirection: Axis.horizontal,
          effect: WormEffect(
            spacing: ds * 0.5,
            dotWidth: ds * 0.7,
            dotHeight: ds * 0.7,
            dotColor: AppColors.grayColor,
            activeDotColor: AppColors.primayColor,
          ),
        ),
      ],
    );
  }
}

import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeSlider extends StatefulWidget {
  HomeSlider({super.key});

  // List<String> sliders = [AppImages.clothes1, AppImages.clothes2];
  final List<String> sliders = [
    AppImages.clothes1,
    AppImages.clothes2,
   
  ];

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.sliders.length,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    widget.sliders[itemIndex],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              },
          options: CarouselOptions(
            height: 150,
            // aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: activeIndex,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
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
        Gap(15),
        AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: widget.sliders.length,
          axisDirection: Axis.horizontal,
          effect: WormEffect(
            spacing: 5,
            dotWidth: 7,
            dotHeight: 7,
            dotColor: AppColors.grayColor,
            activeDotColor: AppColors.primayColor,
          ),
        ),
      ],
    );
  }
}

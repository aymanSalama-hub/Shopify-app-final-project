import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/size_responsive.dart';
import '../../../../core/utils/app_colors.dart';


class dotIndicitor extends StatelessWidget {
  const dotIndicitor({super.key, @required this.dotIndex});
  final double? dotIndex;
  @override
  Widget build(BuildContext context) {
    return  Positioned(
        bottom: Sizeresponsive.defaultSize! * 14,
        right: 0,
        left: 0,
        child: DotsIndicator(

          dotsCount: 3,

          position: dotIndex ?? 0.0,
          decorator: DotsDecorator(activeColor: AppColors.primayColor,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), side:BorderSide(color:AppColors.primayColor))

          ),
        ));
  }
}

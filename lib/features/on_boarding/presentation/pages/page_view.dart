import 'package:flutter/material.dart';


import '../../../../core/constants/orientation_util.dart';
import '../../../../core/constants/size_responsive.dart';

class PageViewItem extends StatelessWidget {
  const PageViewItem({super.key, this.image, this.title, this.subtitle});

  final String? image;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    Sizeresponsive().init(context);

    return OrientationUtil.isPortrait(context)
        ? Column(
      children: [
        Spacer(flex: 2),


        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizeresponsive.screenWidth!*0.025),
            child: Image.asset(
              image!,
              fit: BoxFit.contain,
            ),
          ),
        ),


        Spacer(flex: 1),
        Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: Sizeresponsive.defaultSize! * 0.5),


        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizeresponsive.defaultSize! * 2.4),
          child: Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        Spacer(flex: 3),
      ],
    )

        : Column(
      children: [
       SizedBox(height: Sizeresponsive.screenHeight!*0.006),
        Expanded(
          flex: 3,
          child: Image.asset(
            image!,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: Sizeresponsive.screenHeight!*0.006),
        Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: Sizeresponsive.screenHeight!*0.005),
      ],
    );
  }
}

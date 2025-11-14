import 'package:Shopify/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  AppBarWithBack({super.key, this.action, required this.context});

  final Widget? action;
  BuildContext? context;

  @override
  Widget build(context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: SvgPicture.asset(AppImages.backSvg),
      ),
      centerTitle: false,

      actions: [action ?? const SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

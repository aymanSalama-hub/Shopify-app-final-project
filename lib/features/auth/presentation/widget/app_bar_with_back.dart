import 'package:Shopify/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithBack({super.key, this.action});

  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // to remove the default back button
      centerTitle: false,
      title: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: SvgPicture.asset(AppImages.backSvg),
      ),
      actions: [action ?? const SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

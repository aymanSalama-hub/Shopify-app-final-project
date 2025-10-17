import 'package:flutter/material.dart';

import '../constants/size_responsive.dart';
import 'app_colors.dart';


class Genral_Button extends StatelessWidget {
  const Genral_Button({super.key, required this.text, required this.ontap});

  final VoidCallback? ontap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 60,
        width: Sizeresponsive.screenWidth,
        decoration: BoxDecoration(
            color: AppColors.primayColor, borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
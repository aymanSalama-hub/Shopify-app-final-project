import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(30),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.borderColor.withOpacity(0.6),
                thickness: 1,
              ),
            ),
            const Gap(10),
            Text(
              AppStrings.or,
              style: TextStyles.styleSize15.copyWith(color: Colors.grey[700]),
            ),
            const Gap(10),
            Expanded(
              child: Divider(
                color: AppColors.borderColor.withOpacity(0.6),
                thickness: 1,
              ),
            ),
          ],
        ),
        const Gap(25),
        SocialButton(
          image: AppImages.googleSvg,
          label: AppStrings.loginWithGoogle,
          onPressed: () {
            // TODO: Add Google login logic
          },
        ),
        const Gap(15),
        SocialButton(
          image: AppImages.appleSvg,
          label: AppStrings.loginWithApple,
          onPressed: () {
            // TODO: Add Apple login logic
          },
        ),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  final String image;
  final String label;
  final Function() onPressed;

  const SocialButton({
    super.key,
    required this.image,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFF6C63FF),
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.borderColor.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              height: 22,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
            const Gap(10),
            Text(
              label,
              style: TextStyles.styleSize15.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

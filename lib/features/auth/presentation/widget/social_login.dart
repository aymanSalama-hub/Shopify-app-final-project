import 'package:bisky_shop/core/constants/app_images.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/utils/text_styles.dart';
import 'package:bisky_shop/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bisky_shop/features/auth/presentation/cubit/auths_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is AuthsLoadingState) {
            showdialog(context);
          } else if (state is AuthsSuccessState) {
            pop(context);
            pushAndRemoveUntil(
              context,
              Routs.mainAppNavigation,
              extra: cubit.name.text,
            );
          } else if (state is AuthsErrorState) {
            pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login Failed'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: Column(
          children: [
            const Gap(20),

            // Modern Divider with Text
            _buildDividerWithText(),

            const Gap(35),

            // Social Buttons Grid
            _buildSocialButtons(cubit),

            const Gap(10),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerWithText() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(color: Colors.grey, thickness: 1, height: 1),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.backgroundColorCart,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            AppStrings.or,
            style: TextStyles.styleSize15.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(AuthCubit cubit) {
    return SocialButton(
      image: AppImages.googleSvg,
      label: AppStrings.loginWithGoogle,
      backgroundColor: Colors.white,
      textColor: Colors.black87,
      borderColor: Colors.grey,
      iconColor: null, // Use original colors
      onPressed: () {
        cubit.loginWithGoogle();
      },
    );
  }
}

class SocialButton extends StatelessWidget {
  final String image;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color? iconColor;
  final Function() onPressed;
  final bool hasShadow;

  const SocialButton({
    super.key,
    required this.image,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.iconColor,
    required this.onPressed,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: hasShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Social Icon
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                child: SvgPicture.asset(image, height: 22, width: 22),
              ),
              const Gap(12),

              // Button Text
              Flexible(
                child: Text(
                  label,
                  style: TextStyles.styleSize15.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: -0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

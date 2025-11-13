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
    final theme = Theme.of(context);
    var cubit = context.read<AuthCubit>();
    
    // Dynamic colors based on theme
    final backgroundColor = theme.colorScheme.background;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final surfaceColor = theme.colorScheme.surface;
    final outlineColor = theme.colorScheme.outline;

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
                content: Text(
                  'Login Failed',
                  style: TextStyle(color: theme.colorScheme.onError),
                ),
                backgroundColor: theme.colorScheme.error,
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
            _buildDividerWithText(theme),

            const Gap(35),

            // Social Buttons Grid
            _buildSocialButtons(cubit, theme),

            const Gap(10),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerWithText(ThemeData theme) {
    final backgroundColor = theme.colorScheme.background;
    final textColor = theme.colorScheme.onSurface.withOpacity(0.7);

    return Stack(
      alignment: Alignment.center,
      children: [
        Divider(
          color: theme.colorScheme.outline.withOpacity(0.3), 
          thickness: 1, 
          height: 1
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            AppStrings.or,
            style: TextStyles.styleSize15.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(AuthCubit cubit, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    return SocialButton(
      image: AppImages.googleSvg,
      label: AppStrings.loginWithGoogle,
      backgroundColor: isDark ? theme.colorScheme.surface : Colors.white,
      textColor: isDark ? theme.colorScheme.onSurface : Colors.black87,
      borderColor: theme.colorScheme.outline.withOpacity(0.3),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                      color: isDark 
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: isDark 
                          ? Colors.black.withOpacity(0.2)
                          : Colors.black.withOpacity(0.04),
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
                child: SvgPicture.asset(
                  image, 
                  height: 22, 
                  width: 22,
                  colorFilter: iconColor != null 
                      ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                      : null,
                ),
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

// Helper function to show loading dialog
void showdialog(BuildContext context) {
  final theme = Theme.of(context);
  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Signing in...',
                style: TextStyle(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
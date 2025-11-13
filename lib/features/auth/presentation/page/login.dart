import 'package:bisky_shop/core/constants/app_constants.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bisky_shop/features/auth/presentation/cubit/auths_states.dart';
import 'package:bisky_shop/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:bisky_shop/features/auth/presentation/widget/password_text_form_field.dart';
import 'package:bisky_shop/features/auth/presentation/widget/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var cubit = context.read<AuthCubit>();

    // Dynamic colors based on theme
    final backgroundColor = theme.colorScheme.background;
    final textColor = theme.colorScheme.onBackground;
    final subtitleColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final primaryColor = theme.colorScheme.primary;
    final errorColor = theme.colorScheme.error;
    final borderColor = theme.colorScheme.outline.withOpacity(0.2);

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) async {
        if (state is AuthsLoadingState) {
          showdialog(context);
        } else if (state is AuthsSuccessState) {
          pop(context);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          if (cubit.role == 'Admin') {
            pushAndRemoveUntil(context, Routs.order);
          } else {
            pushAndRemoveUntil(
              context,
              Routs.mainAppNavigation,
              extra: cubit.name.text,
            );
          }
        } else if (state is AuthsErrorState) {
          pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login Failed',
                style: TextStyle(color: theme.colorScheme.onError),
              ),
              backgroundColor: errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: AppConstants.bodyPadding.copyWith(top: 24, bottom: 24),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(50),
                    // Header Section
                    _buildHeaderSection(textColor, subtitleColor),

                    const Gap(40),

                    // Form Section
                    _buildFormSection(cubit, theme),

                    const Gap(24),

                    // Login Button
                    _buildLoginButton(cubit, theme, primaryColor),

                    const Gap(32),
                    // Social Login
                    const SocialLogin(),

                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom Navigation - Register Link
        bottomNavigationBar: _buildBottomNavigationBar(
          theme,
          textColor,
          subtitleColor,
          primaryColor,
        ),
      ),
    );
  }

  Widget _buildHeaderSection(Color textColor, Color subtitleColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeBack,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const Gap(12),
        Text(
          "Sign in to continue shopping with us",
          style: TextStyle(
            color: subtitleColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(AuthCubit cubit, ThemeData theme) {
    return Column(
      children: [
        // Email Field
        CustomTextFormField(
          controller: cubit.email,
          focusNode: _emailFocusNode,
          hintText: AppStrings.emailHint,
          prefixIcon: Icon(
            Icons.email_rounded,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
        ),
        const Gap(20),

        // Password Field
        PasswordTextFormField(
          controller: cubit.password,
          focusNode: _passwordFocusNode,
          hintText: AppStrings.passwordHint,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            _performLogin(cubit);
          },
        ),
      ],
    );
  }

  Widget _buildLoginButton(
    AuthCubit cubit,
    ThemeData theme,
    Color primaryColor,
  ) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: state is AuthsLoadingState
                ? null
                : () => _performLogin(cubit),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              shadowColor: primaryColor.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: state is AuthsLoadingState
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  )
                : const Text(
                    AppStrings.login,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(
    ThemeData theme,
    Color textColor,
    Color subtitleColor,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(color: subtitleColor, fontSize: 15),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () {
              pushTo(context, Routs.register);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Text(
              'Register',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogin(AuthCubit cubit) {
    if (formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      cubit.login();
    }
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Signing In...',
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

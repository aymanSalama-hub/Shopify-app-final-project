import 'package:bisky_shop/core/constants/app_constants.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:bisky_shop/features/auth/presentation/cubit/auths_states.dart';
import 'package:bisky_shop/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:bisky_shop/features/auth/presentation/widget/password_text_form_field.dart';
import 'package:bisky_shop/features/auth/presentation/widget/social_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
    var cubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthsLoadingState) {
          showdialog(context);
        } else if (state is AuthsSuccessState) {
          pop(context);
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
      child: Scaffold(
        backgroundColor: AppColors.backgroundColorCart,
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
                    _buildHeaderSection(),

                    const Gap(40),

                    // Form Section
                    _buildFormSection(cubit),

                    const Gap(24),

                    // Login Button
                    _buildLoginButton(cubit),

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
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeBack,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const Gap(12),
        Text(
          "Sign in to continue shopping with us",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(AuthCubit cubit) {
    return Column(
      children: [
        // Email Field
        CustomTextFormField(
          controller: cubit.email,
          focusNode: _emailFocusNode,
          hintText: AppStrings.emailHint,
          prefixIcon: Icon(Icons.email_rounded),
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

  Widget _buildLoginButton(AuthCubit cubit) {
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
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              shadowColor: const Color(0xFF6C63FF).withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: state is AuthsLoadingState
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.8),
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

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundColorCart,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(color: Colors.grey[700], fontSize: 15),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () {
              pushTo(context, Routs.register);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                color: Color(0xFF6C63FF),
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
      // Unfocus keyboard when submitting
      FocusScope.of(context).unfocus();
      cubit.login();
    }
  }
}

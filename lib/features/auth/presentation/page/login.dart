import 'package:bisky_shop/core/constants/app_constants.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/widgets/app_bar_with_back.dart';
import 'package:bisky_shop/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:bisky_shop/features/auth/presentation/widget/password_text_form_field.dart';
import 'package:bisky_shop/features/auth/presentation/widget/social_login.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorCart,
      appBar: AppBarWithBack(context: context),
      body: SafeArea(
        child: Padding(
          padding: AppConstants.bodyPadding,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(11),

                  /// 🔹 Title
                  Center(
                    child: Text(
                      AppStrings.welcomeBack,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Center(
                    child: Text(
                      "Sign in to continue shopping with us",
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ),

                  const Gap(30),

                  /// 🔹 Email Field
                  CustomTextFormField(
                    controller: emailController,
                    hintText: AppStrings.emailHint,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                  ),
                  const Gap(16),

                  /// 🔹 Password Field
                  PasswordTextFormField(
                    controller: passwordController,
                    hintText: AppStrings.passwordHint,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                  ),

                  const Gap(6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        AppStrings.forgotPassword,
                        style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const Gap(14),

                  /// 🔹 Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          pushAndRemoveUntil(context, Routs.mainAppNavigation);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                        shadowColor: const Color(0xFF6C63FF).withOpacity(0.4),
                      ),
                      child: const Text(
                        AppStrings.login,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const Gap(20),

                  /// 🔹 Social Login Section
                  const SocialLogin(),

                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),

      /// 🔹 Register Link
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(color: Colors.grey[800]),
              ),
              TextButton(
                onPressed: () {
                  pushTo(context, Routs.register);
                },
                child: const Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

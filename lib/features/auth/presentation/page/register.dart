import 'package:bisky_shop/core/constants/app_constants.dart';
import 'package:bisky_shop/core/constants/app_strings.dart';
import 'package:bisky_shop/core/routes/navigation.dart';
import 'package:bisky_shop/core/routes/routs.dart';
import 'package:bisky_shop/core/utils/app_colors.dart';
import 'package:bisky_shop/core/widgets/app_bar_with_back.dart';
import 'package:bisky_shop/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:bisky_shop/features/auth/presentation/widget/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorCart,
      appBar: AppBarWithBack(context: context),
      body: SafeArea(
        child: Padding(
          padding: AppConstants.bodyPadding,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(30),

                  /// 🔹 Illustration

                  /// 🔹 Title
                  Center(
                    child: Text(
                      "Create an Account",
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
                      "Join us and start your shopping journey!",
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ),

                  const Gap(35),

                  /// 🔹 Name Field
                  CustomTextFormField(
                    controller: nameController,
                    hintText: 'Name',
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const Gap(16),

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
                  const Gap(16),

                  /// 🔹 Confirm Password Field
                  PasswordTextFormField(
                    controller: confirmPasswordController,
                    hintText: AppStrings.passwordConfirmation,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const Gap(30),

                  /// 🔹 Register Button
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
                        AppStrings.register,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),

      /// 🔹 Login Link
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(color: Colors.grey[800]),
              ),
              TextButton(
                onPressed: () {
                  pushReplacementTo(context, Routs.login);
                },
                child: const Text(
                  'Login',
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

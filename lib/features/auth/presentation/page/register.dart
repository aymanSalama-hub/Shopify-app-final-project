import 'package:Shopify/core/constants/app_constants.dart';
import 'package:Shopify/core/constants/app_strings.dart';
import 'package:Shopify/core/constants/user_type.dart';
import 'package:Shopify/core/routes/navigation.dart';
import 'package:Shopify/core/routes/routs.dart';
import 'package:Shopify/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:Shopify/features/auth/presentation/cubit/auths_states.dart';
import 'package:Shopify/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:Shopify/features/auth/presentation/widget/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

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
    final surfaceColor = theme.colorScheme.surface;

    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthsLoadingState) {
          showdialog(context);
        } else if (state is AuthsSuccessState) {
          pop(context);
          print(cubit.name.text);
          pushAndRemoveUntil(context, Routs.login);
        } else if (state is AuthsErrorState) {
          pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Register Failed',
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
            padding: AppConstants.bodyPadding,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(50),

                    /// 🔹 Title
                    Center(
                      child: Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Center(
                      child: Text(
                        "Join us and start your shopping journey!",
                        style: TextStyle(color: subtitleColor, fontSize: 15),
                      ),
                    ),

                    const Gap(35),

                    /// 🔹 Name Field
                    CustomTextFormField(
                      controller: cubit.name,
                      hintText: 'Name',
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    const Gap(16),

                    /// 🔹 Email Field
                    CustomTextFormField(
                      controller: cubit.email,
                      hintText: AppStrings.emailHint,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else if (cubit.selectedUserType == UserType.admin &&
                            value.endsWith('@admin.com') == false) {
                          return 'You are not allowed to register as admin';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),

                    /// 🔹 Password Field
                    PasswordTextFormField(
                      controller: cubit.password,
                      hintText: AppStrings.passwordHint,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),

                    /// 🔹 Confirm Password Field
                    PasswordTextFormField(
                      controller: cubit.confirmPassword,
                      hintText: AppStrings.passwordConfirmation,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != cubit.password.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const Gap(16),

                    /// 🔹 User Type Selection
                    Container(
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SegmentedButton<UserType>(
                          segments: [
                            ButtonSegment<UserType>(
                              value: UserType.customer,
                              label: Text(
                                'Customer',
                                style: TextStyle(
                                  color:
                                      cubit.selectedUserType ==
                                          UserType.customer
                                      ? theme.colorScheme.onPrimary
                                      : textColor,
                                ),
                              ),
                            ),
                            ButtonSegment<UserType>(
                              value: UserType.admin,
                              label: Text(
                                'Admin',
                                style: TextStyle(
                                  color:
                                      cubit.selectedUserType == UserType.admin
                                      ? theme.colorScheme.onPrimary
                                      : textColor,
                                ),
                              ),
                            ),
                          ],
                          selected: {cubit.selectedUserType},
                          onSelectionChanged: (newSelection) {
                            setState(() {
                              cubit.selectedUserType = newSelection.first;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>((
                                  Set<MaterialState> states,
                                ) {
                                  if (states.contains(MaterialState.selected)) {
                                    return primaryColor;
                                  }
                                  return Colors.transparent;
                                }),
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return BorderSide(color: primaryColor);
                                }
                                return BorderSide(
                                  color: theme.colorScheme.outline.withOpacity(
                                    0.3,
                                  ),
                                );
                              },
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),

                    /// 🔹 Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await cubit.signUp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                          shadowColor: primaryColor.withOpacity(0.4),
                        ),
                        child: BlocBuilder<AuthCubit, AuthStates>(
                          builder: (context, state) {
                            return state is AuthsLoadingState
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.onPrimary.withOpacity(
                                          0.8,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Text(
                                    AppStrings.register,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                          },
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
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: backgroundColor,
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
                  "Already have an account?",
                  style: TextStyle(color: subtitleColor),
                ),
                TextButton(
                  onPressed: () {
                    pushReplacementTo(context, Routs.login);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Creating Account...',
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

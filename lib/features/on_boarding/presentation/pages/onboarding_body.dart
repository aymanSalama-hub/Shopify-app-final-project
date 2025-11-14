import 'package:Shopify/features/on_boarding/presentation/pages/page_view_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/orientation_util.dart';
import '../../../../core/constants/size_responsive.dart';
import '../../../../core/routes/routs.dart';
import '../../../../core/utils/Custom_Button.dart';
import '../../../../core/utils/app_colors.dart';
import '../widget/dotIndicitor.dart';

class OnBoarding_body extends StatefulWidget {
  const OnBoarding_body({super.key});

  @override
  State<OnBoarding_body> createState() => _OnBoarding_bodyState();
}

class _OnBoarding_bodyState extends State<OnBoarding_body> {
  PageController? pageController;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    context.go(Routs.login);
  }

  @override
  Widget build(BuildContext context) {
    Sizeresponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: OrientationUtil.isPortrait(context)
          ? Stack(
        children: [
          page_view_onboarding(pagecontroller: pageController),
          dotIndicitor(
            dotIndex: pageController!.hasClients
                ? pageController?.page
                : 0,
          ),
          Visibility(
            visible: pageController!.hasClients
                ? (pageController?.page == 2 ? false : true)
                : true,
            child: Positioned(
              top: Sizeresponsive.defaultSize! * 7.5,
              right: Sizeresponsive.defaultSize! * 3.2,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: Sizeresponsive.defaultSize! * 5,
            right: Sizeresponsive.defaultSize! * 10,
            left: Sizeresponsive.defaultSize! * 10,
            child: Genral_Button(
              text: pageController!.hasClients
                  ? (pageController?.page == 2 ? 'Get Started' : 'Next')
                  : 'Next',
              ontap: () {
                if (pageController!.page! < 2) {
                  pageController?.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                } else {
                  _completeOnboarding();
                }
              },
            ),
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: page_view_onboarding(
                    pagecontroller: pageController,
                  ),
                ),
                const SizedBox(height: 10),
                dotIndicitor(
                  dotIndex: pageController!.hasClients
                      ? pageController?.page
                      : 0,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Visibility(
                      visible: pageController!.hasClients
                          ? (pageController?.page == 2 ? false : true)
                          : true,
                      child: TextButton(
                        onPressed: _completeOnboarding,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Genral_Button(
                    text: pageController!.hasClients
                        ? (pageController?.page == 2
                        ? 'Get Started'
                        : 'Next')
                        : 'Next',
                    ontap: () {
                      if (pageController!.page! < 2) {
                        pageController?.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

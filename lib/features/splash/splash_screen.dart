import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/orientation_util.dart';
import '../../core/constants/size_responsive.dart';
import '../../core/routes/routs.dart';
import '../../core/utils/app_colors.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeLogo;
  late Animation<double> _fadeText;
  late Animation<double> _scaleLogo;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _fadeLogo = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _fadeText = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 1.0, curve: Curves.easeInOut)),
    );

    _scaleLogo = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Sizeresponsive().init(context);
    });

    Future.delayed(const Duration(seconds: 4), () {
      _checkNavigation();
    });
  }

  Future<void> _checkNavigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!seenOnboarding) {
      context.go(Routs.onboarding);
    } else if (!isLoggedIn) {
      context.go(Routs.login);
    } else {
      context.go(Routs.mainAppNavigation);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Sizeresponsive().init(context);

    return Scaffold(
      backgroundColor: AppColors.primayColor,
      body: SafeArea(
        child: Center(
          child: OrientationUtil.isPortrait(context)
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleLogo,
                child: FadeTransition(
                  opacity: _fadeLogo,
                  child: SizedBox(
                    height: Sizeresponsive.screenHeight! * 0.35,
                    width: Sizeresponsive.screenWidth! * 0.55,
                    child: Image.asset(
                      'assets/icons/splash.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Sizeresponsive.defaultSize! * 3),
              FadeTransition(
                opacity: _fadeText,
                child: Text(
                  'Shopify',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizeresponsive.defaultSize! * 5.2,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ScaleTransition(
                  scale: _scaleLogo,
                  child: FadeTransition(
                    opacity: _fadeLogo,
                    child: Image.asset(
                      'assets/icons/splash.png',
                      fit: BoxFit.contain,
                      height: Sizeresponsive.screenHeight!*0.6,
                    ),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeText,
                child: Padding(
                  padding:  EdgeInsets.only(right: Sizeresponsive.defaultSize! * 12,top:Sizeresponsive.defaultSize! * 5 ),
                  child: Text(
                    'Shopify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizeresponsive.defaultSize! * 5,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
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

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:myspp_app/pages/onboard.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int? isViewed;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/img/logo.png',
      nextScreen: const Onboard(),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 200,
    );
  }
}

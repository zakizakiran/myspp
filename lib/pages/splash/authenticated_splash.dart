import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:myspp_app/navigation/navbar.dart';

class AuthenticatedSplash extends StatefulWidget {
  const AuthenticatedSplash({super.key});

  @override
  State<AuthenticatedSplash> createState() => _AuthenticatedSplashState();
}

class _AuthenticatedSplashState extends State<AuthenticatedSplash> {
  int? isViewed;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/img/logo.png',
      nextScreen: const Navigation(),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 200,
    );
  }
}

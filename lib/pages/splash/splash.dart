import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/pages/onboard.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    super.initState();
  }

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

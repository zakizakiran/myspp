import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/components/navigation/navbar_petugas.dart';

class PetugasSplash extends ConsumerStatefulWidget {
  const PetugasSplash({super.key});

  @override
  ConsumerState<PetugasSplash> createState() => _PetugasSplashState();
}

class _PetugasSplashState extends ConsumerState<PetugasSplash> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    await ref.read(authControllerProvider.notifier).checkUsers(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/img/logo.png',
      nextScreen: Builder(builder: (context) {
        return const PetugasNavigation();
      }),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 250,
    );
  }
}

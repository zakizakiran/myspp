import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/components/navigation/navbar_user.dart';

class UserSplash extends ConsumerStatefulWidget {
  const UserSplash({super.key});

  @override
  ConsumerState<UserSplash> createState() => UserSplashState();
}

class UserSplashState extends ConsumerState<UserSplash> {
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
        return const UserNavigation();
      }),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 250,
    );
  }
}

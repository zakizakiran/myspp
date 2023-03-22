import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/navigation/navbar_admin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSplash extends ConsumerStatefulWidget {
  const AdminSplash({super.key});

  @override
  ConsumerState<AdminSplash> createState() => _AdminSplashState();
}

class _AdminSplashState extends ConsumerState<AdminSplash> {
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
        return const AdminNavigation();
      }),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 250,
    );
  }
}

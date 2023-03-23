import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/components/animations/showup.dart';
import 'package:myspp_app/pages/auth/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30.0, left: 30.0),
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Selamat datang di',
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 3000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'MySpp',
                    style: TextStyle(
                        color: HexColor('3E3592'),
                        fontSize: 36,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Berikan kemudahan!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40.0),
            Center(
              child: SvgPicture.asset('assets/img/hello.svg'),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20.0),
              child: ShowUp(
                delay: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: HexColor('673ab7'),
                        padding: const EdgeInsets.all(15.0),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

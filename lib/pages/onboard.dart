import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/pages/auth/login.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ignore: avoid_unnecessary_containers
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30.0, left: 30.0),
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat datang di',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Image.asset(
                    'assets/img/splash.png',
                    width: 120.0,
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'My',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.w600,
                  //           fontSize: 36,
                  //           color: HexColor('7286D3')),
                  //     ),
                  //     const Text(
                  //       'Spp.',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 36,
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                      backgroundColor: HexColor('204FA1'),
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
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: HexColor('FFFFFF'),
                      padding: const EdgeInsets.all(15.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      side: BorderSide(
                        color: HexColor('204FA1'),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: HexColor('204FA1'),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

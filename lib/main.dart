import 'package:flutter/material.dart';
import 'package:myspp_app/pages/onboard.dart';
import 'package:myspp_app/pages/splash/splash.dart';

void main() {
  runApp(const MySppApp());
}

class MySppApp extends StatelessWidget {
  const MySppApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand'),
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}

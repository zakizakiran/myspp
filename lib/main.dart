import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/components/get_role.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/firebase_options.dart';
import 'package:myspp_app/pages/splash/admin_splash.dart';
import 'package:myspp_app/pages/splash/user_splash.dart';
import 'package:myspp_app/pages/splash/splash.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await RoleName().chooseRole();
  initializeDateFormatting();
  runApp(const ProviderScope(child: MySppApp()));
}

class ServiceAccountCredential {
  ServiceAccountCredential(String s);
}

class MySppApp extends StatelessWidget {
  const MySppApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Quicksand'),
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return FirebaseAuth.instance.currentUser == null
            ? const Splash()
            : AuthController().routeIsAdmin(context)
                ? const AdminSplash()
                : const UserSplash();
      }),
    );
  }
}

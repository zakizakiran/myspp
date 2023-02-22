import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/model/users.dart';
import 'package:myspp_app/navigation/navbar.dart';
import 'package:myspp_app/pages/auth/login.dart';

class AuthController extends StateNotifier<Users> {
  AuthController() : super(Users());

  Future<void> emailPassSignIn(
      BuildContext context, String email, String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: HexColor('#4392A4'),
              ),
            ));
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Navigation(),
          ));

      //   if (credential.user != null) {
      //     var checkUsers = await FirebaseFirestore.instance
      //         .collection('users')
      //         .doc(credential.user!.uid)
      //         .get();
      //     if (!checkUsers.exists) {
      //       return;
      //     } else {
      //       final users = Users.fromJson(checkUsers.data()!);
      //       state = users;
      //     }
      // if (!mounted) return;
      //     // Snackbars().successSnackbars(
      //     //     context, 'Login Succeed', 'Welcome Back to SCHEDUS');

      //   }

      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Snackbars()
      //     .failedSnackbars(context, 'Login Failed', e.message.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: HexColor('#4392A4'),
              ),
            ));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const Login();
        },
      ),
      (_) => false,
    );

    await FirebaseAuth.instance.signOut();

    state = Users();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, Users>(
  (ref) => AuthController(),
);

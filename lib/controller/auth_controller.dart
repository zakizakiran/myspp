// ignore_for_file: use_build_context_synchronously
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:myspp_app/model/users.dart';
import 'package:myspp_app/navigation/navbar.dart';
import 'package:myspp_app/navigation/navbar_admin.dart';
import 'package:myspp_app/pages/auth/forgot_pass/mail_check.dart';
import 'package:myspp_app/pages/auth/login.dart';
import 'package:myspp_app/pages/splash/admin_splash.dart';
import 'package:myspp_app/pages/splash/authenticated_splash.dart';

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
      var credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        var checkUsers = await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .get();
        if (!checkUsers.exists) {
          return;
        } else {
          final users = Users.fromJson(checkUsers.data()!);
          state = users;
        }
      }

      AnimatedSnackBar.rectangle(
        'Login Success',
        'Welcome back here!',
        type: AnimatedSnackBarType.success,
        brightness: Brightness.light,
        mobileSnackBarPosition: MobileSnackBarPosition.bottom,
        duration: const Duration(milliseconds: 10),
      ).show(
        context,
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
      route(context);
    } on FirebaseAuthException catch (e) {
      var error = e.message.toString();
      AnimatedSnackBar.rectangle('Login Failed', error,
              type: AnimatedSnackBarType.error,
              brightness: Brightness.light,
              mobileSnackBarPosition: MobileSnackBarPosition.top,
              duration: const Duration(milliseconds: 80))
          .show(
        context,
      );
      Navigator.pop(context);
    }
  }

  Future<void> emailPassSignUp(
      BuildContext context,
      String email,
      String password,
      String nama,
      String kelas,
      String telp,
      String nis,
      String nisn,
      String alamat) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: HexColor('#4392A4'),
              ),
            ));
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // var checkUsers = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(credential.user!.uid)
      //     .get();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'email': email,
        'role': 'siswa',
        'nisn': nisn,
        'nis': nis,
        'nama': nama,
        'kelas': kelas,
        'alamat': alamat,
        'telp': telp
      });
      // final users = Users(
      //     uid: credential.user!.uid,
      //     email: email,
      //     role: 'siswa',
      //     nisn: nisn,
      //     nis: nis,
      //     nama: nama,
      //     kelas: kelas,
      //     alamat: alamat,
      //     telp: telp);
      // state = users;
      if (!mounted) return;
      AnimatedSnackBar.rectangle('Daftar Berhasil', 'Selamat datang di MySpp!',
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              duration: const Duration(milliseconds: 80))
          .show(
        context,
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminNavigation(),
          ));
    } on FirebaseAuthException catch (e) {
      var error = e.message.toString();
      AnimatedSnackBar.rectangle('Daftar Gagal', error,
              type: AnimatedSnackBarType.error,
              brightness: Brightness.light,
              mobileSnackBarPosition: MobileSnackBarPosition.top,
              duration: const Duration(milliseconds: 80))
          .show(
        context,
      );
    }
  }

  Future<void> getUsers({required String uid}) async {
    var checkUsers =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final users = Users.fromJson(checkUsers.data()!);
    state = users;
  }

  Future<String> checkUsers(BuildContext context) async {
    final result = FirebaseAuth.instance.currentUser;
    Logger().i(result);
    if (result != null) {
      await getUsers(uid: result.uid);
      // route(context);
      return result.uid;
    }
    return '';
  }

  void route(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminNavigation(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Navigation(),
            ),
          );
        }
      } else {
        return;
      }
    });
  }

  bool routeIsAdmin(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminSplash(),
            ),
          );
          return true;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthenticatedSplash(),
            ),
          );
        }
        return false;
      } else {
        Navigator.of(context).pop();
      }
      return false;
    });
    return false;
  }

  Future<void> forgetPass(BuildContext context, String email) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: HexColor('#4392A4'),
              ),
            ));
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      AnimatedSnackBar.rectangle('Email Sent', 'Check your email!',
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
              mobileSnackBarPosition: MobileSnackBarPosition.top,
              duration: const Duration(milliseconds: 80))
          .show(
        context,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MailCheck()));
    } on FirebaseAuthException catch (e) {
      var error = e.message.toString();
      AnimatedSnackBar.rectangle('Email Send Failed', error,
              type: AnimatedSnackBarType.error,
              brightness: Brightness.light,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              duration: const Duration(milliseconds: 80))
          .show(
        context,
      );
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

    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return const Login();
        },
      ),
      (_) => false,
    );

    state = Users();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, Users>(
  (ref) => AuthController(),
);

import 'dart:developer';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:logger/logger.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/model/users.dart';
import 'package:myspp_app/navigation/navbar_petugas.dart';
import 'package:myspp_app/navigation/navbar_user.dart';
import 'package:myspp_app/navigation/navbar_admin.dart';
import 'package:myspp_app/pages/auth/forgot_pass/mail_check.dart';
import 'package:myspp_app/pages/auth/login.dart';
import 'package:myspp_app/pages/pengguna/data_pengguna.dart';
import 'package:myspp_app/pages/splash/admin_splash.dart';
import 'package:myspp_app/pages/splash/user_splash.dart';

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
            .collection('pengguna')
            .doc(credential.user!.uid)
            .get();
        if (!checkUsers.exists) {
          return;
        } else {
          final users = Users.fromJson(checkUsers.data()!);
          state = users;
        }
      }
      if (!mounted) return;
      Snackbars().successSnackbars(
          context, 'Berhasil Masuk', 'Selamat Datang di MySpp');
      Navigator.of(context).popUntil((route) => route.isFirst);
      route(context);
    } on FirebaseAuthException catch (e) {
      var error = e.message.toString();
      Snackbars().failedSnackbars(context, 'Gagal Masuk', error);
      Navigator.pop(context);
    }
  }

  Future<void> register(BuildContext context, String email, String password,
      String nama, String telp, String alamat, String level) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      var userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('pengguna')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
        'nama': nama,
        'telp': telp,
        'alamat': alamat,
        'level': level,
      });
      final auth = FirebaseAuth.instance;
      final dbLog = FirebaseFirestore.instance.collection('log_history');
      final doc = dbLog.doc();
      await doc.set({
        'log_id': doc.id,
        'aktivitas': 'Membuat akun',
        'email': auth.currentUser!.email,
        'tgl': DateTime.now(),
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DataPengguna()));
      // ignore: use_build_context_synchronously
      Snackbars()
          .successSnackbars(context, 'Berhasil', 'Berhasil Menambah Akun');
    } on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
      log(e.message.toString());
    }

    await app.delete();

    return Future.sync(() => FirebaseAuth.instanceFor(app: app));
  }

  Future<void> registerSiswa(BuildContext context, String email,
      String password, String nama, String telp, String alamat, String level,
      {required String sid, required String nisn}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      var userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('pengguna')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
        'nama': nama,
        'telp': telp,
        'alamat': alamat,
        'level': level,
        'sid': sid,
        'nisn': nisn
      });
      final auth = FirebaseAuth.instance;
      final dbLog = FirebaseFirestore.instance.collection('log_history');
      final doc = dbLog.doc();
      await doc.set({
        'log_id': doc.id,
        'aktivitas': 'Membuat akun',
        'email': auth.currentUser!.email,
        'tgl': DateTime.now(),
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const DataPengguna()));
      // ignore: use_build_context_synchronously
      Snackbars()
          .successSnackbars(context, 'Berhasil', 'Berhasil Menambah Akun');
    } on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
      log(e.message.toString());
    }

    await app.delete();

    return Future.sync(() => FirebaseAuth.instanceFor(app: app));
  }

  Future<void> getUsers({required String uid}) async {
    var checkUsers =
        await FirebaseFirestore.instance.collection('pengguna').doc(uid).get();

    final users = Users.fromJson(checkUsers.data()!);
    state = users;
  }

  Future<String> checkUsers(BuildContext context) async {
    final result = FirebaseAuth.instance.currentUser;
    Logger().i(result);
    if (result != null) {
      await getUsers(uid: result.uid);
      return result.uid;
    }
    return '';
  }

  void route(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    // ignore: unused_local_variable
    var kk = FirebaseFirestore.instance
        .collection('pengguna')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('level') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminNavigation(),
            ),
          );
        } else if (documentSnapshot.get('level') == "Petugas") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PetugasNavigation(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UserNavigation(),
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
        .collection('pengguna')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('level') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminSplash(),
            ),
          );
          return true;
        } else if (documentSnapshot.get('level') == "Petugas") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PetugasNavigation(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UserSplash(),
            ),
          );
        }
        return false;
      } else {
        Navigator.of(context).pop();
      }
      return false;
    });
    return true;
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

      // ignore: use_build_context_synchronously
      AnimatedSnackBar.rectangle('Email Sent', 'Check your email!',
              type: AnimatedSnackBarType.success,
              brightness: Brightness.light,
              mobileSnackBarPosition: MobileSnackBarPosition.top,
              duration: const Duration(milliseconds: 80))
          .show(
        context,
      );
      // ignore: use_build_context_synchronously
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
    // ignore: use_build_context_synchronously
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

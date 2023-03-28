import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/model/users.dart';
import 'package:myspp_app/pages/auth/login.dart';

class UsersController extends StateNotifier<List<Users>> {
  UsersController() : super([]);

  final db = FirebaseFirestore.instance.collection('pengguna');

  Future<void> getUsers() async {
    var checkUser = await db
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<Users> users =
        checkUser.docs.map((e) => Users.fromJson(e.data())).toList();
    state = users;
  }

  Future<void> deleteUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String uid}) async {
    User? userCredential = FirebaseAuth.instance.currentUser!;

    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

    try {
      await userCredential
          .reauthenticateWithCredential(credential)
          .then((value) {
        value.user!.delete().then((res) async {
          final db = FirebaseFirestore.instance.collection('pengguna');
          final doc = db.doc(uid);
          await doc.delete();
          if (!mounted) return;
          Snackbars()
              .successSnackbars(context, 'Berhasil', 'Berhasil Menghapus Akun');
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const Login();
              },
            ),
            (_) => false,
          );
        });
      });
    } on FirebaseAuthException catch (e) {
      Snackbars().failedSnackbars(context, 'Gagal', e.message.toString());
      Navigator.pop(context);
    }
  }
}

final usersControllerProvider =
    StateNotifierProvider<UsersController, List<Users>>(
  (ref) => UsersController(),
);

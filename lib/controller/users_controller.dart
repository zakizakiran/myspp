import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/model/users.dart';

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
      required dynamic password}) async {
    var index = 0;
    index = index++;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary{$index}', options: Firebase.app().options);
    User? userCredential = FirebaseAuth.instanceFor(app: app).currentUser!;

    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

    await userCredential.reauthenticateWithCredential(credential).then((value) {
      value.user!.delete().then((res) {
        Snackbars().successSnackbars(context, 'Berhasl', 'Yeay');
      });

      app.delete();
    });
  }
}

final usersControllerProvider =
    StateNotifierProvider<UsersController, List<Users>>(
  (ref) => UsersController(),
);

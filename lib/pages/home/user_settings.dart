// ignore_for_file: prefer_const_constructors
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/controller/users_controller.dart';

class UserSettings extends ConsumerStatefulWidget {
  const UserSettings({super.key});

  @override
  ConsumerState<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends ConsumerState<UserSettings> {
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authControllerProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: HexColor('673ab7')),
                  width: 50,
                  height: 5,
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentUser.nama.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                currentUser.email.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                currentUser.nisn.toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10.0),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                color: HexColor('204FA1'),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    currentUser.kelas.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Divider(
                thickness: 2.0,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'General',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      confirmDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: HexColor('204FA1'),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: HexColor('204FA1'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      deleteDialog(
                        context,
                        userEmail: currentUser.email.toString(),
                        uid: currentUser.uid.toString(),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: HexColor('204FA1'),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  'Hapus Akun',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              EvaIcons.trash2Outline,
                              color: Colors.redAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  deleteDialog(BuildContext context,
      {required String userEmail, required String uid}) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.all(20.0),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            title: const Text(
              'Apakah anda yakin akan menghapus akun?',
              style: TextStyle(fontSize: 16.0),
            ),
            actions: [
              TextFormField(
                style: const TextStyle(color: Colors.black),
                cursorColor: HexColor('204FA1'),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return 'Kata sandi tidak boleh kosong';
                  }
                  return null;
                }),
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black),
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: HexColor('204FA1'),
                  ),
                  focusColor: Colors.black,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: HexColor('204FA1'), width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2)),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      ref
                          .read(usersControllerProvider.notifier)
                          .deleteUser(
                              context: context,
                              email: userEmail,
                              password: password.text,
                              uid: uid)
                          .toString();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.all(15.0),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0))),
                    child: const Text('Hapus'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.all(15.0),
                        backgroundColor: HexColor('204FA1'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0))),
                    child: const Text('Tidak'),
                  ),
                ],
              )
            ],
          );
        });
  }

  confirmDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.all(20.0),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            title: const Text(
              'Apakah anda yakin untuk keluar?',
              style: TextStyle(fontSize: 16.0),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(authControllerProvider.notifier)
                        .signOut(context);
                  } on FirebaseAuthException catch (e) {
                    Snackbars().failedSnackbars(
                        context, 'Gagal', e.message.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.all(15.0),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0))),
                child: const Text('Keluar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.all(15.0),
                    backgroundColor: HexColor('204FA1'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0))),
                child: const Text('Tidak'),
              ),
            ],
          );
        });
  }
}

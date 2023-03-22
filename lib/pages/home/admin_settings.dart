import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/controller/log_history_controller.dart';

class AdminSettings extends ConsumerStatefulWidget {
  const AdminSettings({super.key});

  @override
  ConsumerState<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends ConsumerState<AdminSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(logHistoryControllerProvider);
    int count = 0;
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'Settings',
        //   style: TextStyle(
        //     fontSize: 22.0,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Column(
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5.0),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: HexColor("FAB464")),
                  width: 50,
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref
                      .read(authControllerProvider.notifier)
                      .signOut(context);
                } on FirebaseAuthException {
                  AnimatedSnackBar.rectangle(
                    'Logout Failed',
                    '',
                    type: AnimatedSnackBarType.error,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  );
                }
              },
              child: const Text('Logout'),
            ),
            logs.isNotEmpty
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: HexColor('204FA1')),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actionsPadding: const EdgeInsets.all(20.0),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              title: const Text(
                                'Apakah anda yakin untuk menghapusnya?',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await ref
                                          .read(logHistoryControllerProvider
                                              .notifier)
                                          .deleteAllLog(
                                              context: context,
                                              email: FirebaseAuth
                                                  .instance.currentUser!.email
                                                  .toString());
                                      setState(() {});
                                      if (!mounted) return;
                                      Navigator.of(context)
                                          .popUntil((_) => count++ >= 2);
                                      Snackbars().successSnackbars(
                                          context,
                                          'Berhasil',
                                          'Berhasil Menghapus Aktivitas');
                                    } on FirebaseException catch (e) {
                                      Snackbars().failedSnackbars(context,
                                          'Gagal', e.message.toString());
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: const BorderSide(
                                          color: Colors.redAccent),
                                      padding: const EdgeInsets.all(15.0),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0))),
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
                                          borderRadius:
                                              BorderRadius.circular(12.0))),
                                  child: const Text('Tidak'),
                                ),
                              ],
                            );
                          });
                    },
                    label: const Text('Hapus semua aktivitas'),
                    icon: const Icon(
                      EvaIcons.trash2Outline,
                      color: Colors.redAccent,
                    ))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

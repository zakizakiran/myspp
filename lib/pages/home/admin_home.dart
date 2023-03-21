import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/components/animations/showup.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/controller/log_history_controller.dart';
import 'package:myspp_app/model/log_history.dart';
import 'package:myspp_app/pages/pengguna/data_pengguna.dart';
import 'package:myspp_app/pages/siswa/data_siswa.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  @override
  void initState() {
    super.initState();
    getAllLog();
  }

  List<LogHistory> logResult = [];

  Future<void> getAllLog() async {
    await ref
        .read(logHistoryControllerProvider.notifier)
        .getLog(email: FirebaseAuth.instance.currentUser!.email.toString());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    var logs = ref.watch(logHistoryControllerProvider);
    String nama = user.nama.toString();
    return Scaffold(
      endDrawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      const Text(
                        'Log Aktvitas',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        splashRadius: 20.0,
                        onPressed: () {
                          getAllLog();
                        },
                        icon: const Icon(
                          EvaIcons.refresh,
                          size: 25.0,
                        ),
                      ),
                      // IconButton(
                      //   splashRadius: 20.0,
                      //   onPressed: () async {
                      //     try {
                      //       await ref
                      //           .read(logHistoryControllerProvider.notifier)
                      //           .deleteAllLog(
                      //               email: FirebaseAuth
                      //                   .instance.currentUser!.email
                      //                   .toString(),
                      //               context: context);

                      //       setState(() {});
                      //       if (!mounted) return;
                      //       Snackbars().successSnackbars(
                      //           context, 'Success', 'Successfully Deleted!');
                      //       Navigator.pop(context);
                      //     } on FirebaseException catch (e) {
                      //       Navigator.pop(context);
                      //       Snackbars().failedSnackbars(
                      //           context, 'Failed To Delete Plan', e.toString());
                      //     }
                      //   },
                      //   icon: const Icon(
                      //     EvaIcons.trash2Outline,
                      //     color: Colors.redAccent,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: HexColor("FAB464")),
                      width: 50,
                      height: 5,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Expanded(
                    child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(logs[index].aktivitas.toString()),
                                Text((logs[index].tgl.toString()))
                              ],
                            ),
                          )),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
      backgroundColor: HexColor('0F0D35'),
      body: ListView(
        children: [
          SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
                          child: Column(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hai, $nama',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Selamat Datang!',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: HexColor('AEAEAE')),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        Builder(builder: (BuildContext context) {
                          return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: Icon(
                                Icons.notes_rounded,
                                color: HexColor('204FA1'),
                              ));
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          SvgPicture.asset(
            'assets/img/admin-hero.svg',
            width: 150.0,
          ),
          const SizedBox(height: 40.0),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: ShowUp(
              delay: 100,
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                  fontSize: 26.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: HexColor("204FA1")),
                              width: 50,
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Expanded(
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 10 / 9,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 12.0,
                          crossAxisCount: 3,
                          children: [
                            menuWidget(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DataSiswa()));
                            }, 'assets/img/siswaWidget.svg'),
                            menuWidget(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DataPengguna()));
                            }, 'assets/img/penggunaWidget.svg'),
                            menuWidget(
                                () {}, 'assets/img/pembayaranWidget.svg'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  menuWidget(dynamic onTap, dynamic appIcon) {
    return TextButton(
      onPressed: onTap,
      child: SvgPicture.asset(
        appIcon,
        width: 100.0,
      ),
      // child: SvgPicture.asset(
      //   appIcon,
      //   width: 10.0,
      // ),
    );
  }
}

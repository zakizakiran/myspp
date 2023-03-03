import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/components/animations/showup.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/pages/pengguna/data_pengguna.dart';
import 'package:myspp_app/pages/siswa/data_siswa.dart';

class AdminHome extends ConsumerStatefulWidget {
  const AdminHome({super.key});

  @override
  ConsumerState<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    String nama = user.nama.toString();
    return Scaffold(
      endDrawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              children: [
                const Text(
                  'Pengguna Online',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
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
                SizedBox(
                  height: 50,
                  width: 250,
                  child: Card(
                    elevation: 0,
                    color: HexColor('D1E7DD'),
                    child: Center(
                        child: Text(
                      'Budi Hartanto',
                      style: TextStyle(
                        color: HexColor('198754'),
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                  ),
                )
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
                                Icons.person_rounded,
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
            'assets/img/admin2.svg',
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

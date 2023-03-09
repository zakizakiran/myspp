import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/controller/auth_controller.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({super.key});

  @override
  ConsumerState<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    String nama = user.nama.toString();

    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Column(
              children: [
                const Text(
                  'Transaksi Terakhir Anda',
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
                    color: HexColor('CFE2FF'),
                    child: Center(
                        child: Text(
                      '12/28/2023',
                      style: TextStyle(
                        color: HexColor('0A58CA'),
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
              height: 250,
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
                          padding: const EdgeInsets.all(12.0),
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
                    const SizedBox(height: 15.0),
                    SvgPicture.asset(
                      'assets/img/transfer.svg',
                      width: 150.0,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Tagihan Anda',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    const SizedBox(width: 8.0),
                    SvgPicture.asset('assets/img/coins.svg')
                  ],
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Rp. 700.000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.48,
            child: Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0.0),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 10 / 8,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  crossAxisCount: 3,
                  children: [
                    menuWidget(() {}, 'assets/img/pembayaranWidget.svg'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  InkWell menuWidget(dynamic onTap, dynamic appIcon) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        appIcon,
        width: 10.0,
      ),
    );
  }
}

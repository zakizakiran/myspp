import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myspp_app/components/animations/showup.dart';
import 'package:myspp_app/controller/auth_controller.dart';
import 'package:myspp_app/controller/pembayaran_controller.dart';
import 'package:myspp_app/controller/pembayaran_history_controller.dart';
import 'package:myspp_app/model/pembayaran.dart';
import 'package:myspp_app/pages/pembayaran/data_pembayaran_user.dart';

class UserHome extends ConsumerStatefulWidget {
  const UserHome({super.key});

  @override
  ConsumerState<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends ConsumerState<UserHome> {
  @override
  void initState() {
    super.initState();
    getPembayaranUser();
    getHistoryPembayaran();
  }

  List<Pembayaran> pembayaranResult = [];

  Future<void> getPembayaranUser() async {
    await ref.read(pembayaranControllerProvider.notifier).getPembayaranUser();
  }

  Future<void> getHistoryPembayaran() async {
    await ref
        .read(pembayaranHistoryControllerProvider.notifier)
        .getHistoryUser(email: FirebaseAuth.instance.currentUser!.email);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider);
    final pembayaran = ref.watch(pembayaranControllerProvider);
    final pembayaranTotal =
        pembayaran.where((element) => element.nisn == user.nisn);
    final riwayatPembayaran = ref.watch(pembayaranHistoryControllerProvider);

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
                  'Riwayat Pembayaran',
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
                          color: HexColor('204FA1')),
                      width: 50,
                      height: 5,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Expanded(
                    child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: riwayatPembayaran.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Text(
                                    riwayatPembayaran[index]
                                        .bulanBayar
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    riwayatPembayaran[index]
                                        .tahunBayar
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]),
                                const SizedBox(height: 8.0),
                                Text(NumberFormat.simpleCurrency(
                                        locale: 'id', name: 'Rp. ')
                                    .format(riwayatPembayaran[index].jmlBayar)),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat.yMMMMEEEEd('id').format(
                                          DateTime.tryParse(
                                              riwayatPembayaran[index]
                                                  .tgl
                                                  .toString())!),
                                      style: TextStyle(
                                        color: HexColor('204FA1'),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      DateFormat.Hm('id').format(
                                          DateTime.tryParse(
                                              riwayatPembayaran[index]
                                                  .tgl
                                                  .toString())!),
                                      style: TextStyle(
                                        color: HexColor('204FA1'),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
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
          SizedBox(
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
                        padding: const EdgeInsets.all(15.0),
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
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: Icon(
                                Icons.history_rounded,
                                color: HexColor('204FA1'),
                              )),
                        );
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
          SizedBox(height: MediaQuery.of(context).size.height / 7),
          ShowUp(
            delay: 100,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.43,
              child: Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tagihan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: HexColor('204FA1')),
                          ),
                          TextButton(
                            style:
                                TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Text(
                              'Total | ${pembayaranTotal.length}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400]),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DataPembayaranUser()));
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 50.0),
                            itemCount: pembayaran.take(2).length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  DetailBottomSheet(
                                      context: context,
                                      pembayaran: pembayaran[index],
                                      result: index);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Tagihan Bulan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              children: [
                                                Text(pembayaran[index]
                                                    .bulanBayar
                                                    .toString()),
                                                const SizedBox(width: 5.0),
                                                Text(pembayaran[index]
                                                    .tahunBayar
                                                    .toString()),
                                              ],
                                            ),
                                            const SizedBox(height: 8.0),
                                            const Text(
                                              'Jumlah Tagihan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5.0),
                                            pembayaran[index].jmlTagihan == 0
                                                ? const Text('-')
                                                : Text(
                                                    NumberFormat.simpleCurrency(
                                                            locale: 'id',
                                                            name: 'Rp. ')
                                                        .format(
                                                            pembayaran[index]
                                                                .jmlTagihan))
                                          ],
                                        ),
                                        pembayaran[index].jmlTagihan == 0
                                            ? Card(
                                                color: Colors.greenAccent[100],
                                                margin: EdgeInsets.zero,
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3.0,
                                                      horizontal: 10.0),
                                                  child: Text(
                                                    'Lunas',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ))
                                            : Card(
                                                color: Colors.grey[200],
                                                margin: EdgeInsets.zero,
                                                child: const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 3.0,
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    'Belum Lunas',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                    ),
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

  // ignore: non_constant_identifier_names
  Future<dynamic> DetailBottomSheet(
      {required BuildContext context,
      required Pembayaran pembayaran,
      required dynamic result}) {
    return showMaterialModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        // ignore: sized_box_for_whitespace
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: Colors.grey[300]),
                              width: 20,
                              height: 5,
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Detail Tagihan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        'Tagihan Bulan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(pembayaran.bulanBayar.toString()),
                          const SizedBox(width: 4.0),
                          Text(pembayaran.tahunBayar.toString())
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Total Tagihan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      pembayaran.jmlTagihan == 0
                          ? const Text('-')
                          : Text(NumberFormat.simpleCurrency(
                                  locale: 'id', name: 'Rp. ')
                              .format(pembayaran.jmlTagihan)),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Jumlah Bayar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(NumberFormat.simpleCurrency(
                              locale: 'id', name: 'Rp. ')
                          .format(pembayaran.jmlBayar)),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Petugas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(pembayaran.namaPetugas.toString()),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Tagihan Dibuat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(DateFormat.yMMMMEEEEd('id').format(
                          DateTime.tryParse(pembayaran.tglDibuat.toString())!)),
                      const SizedBox(height: 10.0),
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      pembayaran.jmlTagihan == 0
                          ? Card(
                              color: Colors.greenAccent[100],
                              margin: EdgeInsets.zero,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 10.0),
                                child: Text(
                                  'Lunas',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ))
                          : Card(
                              color: Colors.grey[200],
                              margin: EdgeInsets.zero,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.0, horizontal: 8.0),
                                child: Text(
                                  'Belum Lunas',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )),
                    ],
                  ),
                ),
              ]),
            ));
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myspp_app/controller/pembayaran_controller.dart';
import 'package:myspp_app/controller/pembayaran_history_controller.dart';
import 'package:myspp_app/model/pembayaran.dart';

class DataPembayaranUser extends ConsumerStatefulWidget {
  const DataPembayaranUser({super.key});

  @override
  ConsumerState<DataPembayaranUser> createState() => _DataPembayaranUserState();
}

class _DataPembayaranUserState extends ConsumerState<DataPembayaranUser> {
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
    final pembayaran = ref.watch(pembayaranControllerProvider);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0))),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        flexibleSpace: SafeArea(
          child: Column(
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Data Pembayaran',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: HexColor('0F0D35'),
      body: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          const Center(
              child: Text(
            'Seluruh Tagihan Anda',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          )),
          const SizedBox(height: 45.0),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.4,
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
                  Expanded(
                    child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0.0),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 50.0),
                          itemCount: pembayaran.length,
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
                                                      .format(pembayaran[index]
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

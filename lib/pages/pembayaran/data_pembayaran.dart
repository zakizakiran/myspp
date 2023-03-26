import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myspp_app/components/bukti_pembayaran.dart';
import 'package:myspp_app/controller/pembayaran_controller.dart';
import 'package:myspp_app/model/pembayaran.dart';
import 'package:myspp_app/pages/pembayaran/lunas_pembayaran.dart';

class DataPembayaran extends ConsumerStatefulWidget {
  const DataPembayaran({super.key});

  @override
  ConsumerState<DataPembayaran> createState() => _DataPembayaranState();
}

class _DataPembayaranState extends ConsumerState<DataPembayaran> {
  final PdfInvoiceService service = PdfInvoiceService();

  @override
  void initState() {
    super.initState();
    getAllPembayaran();
  }

  List<Pembayaran> pembayaranResult = [];

  Future<void> getAllPembayaran() async {
    await ref.read(pembayaranControllerProvider.notifier).getPembayaran();
  }

  @override
  Widget build(BuildContext context) {
    var pembayaran = ref.watch(pembayaranControllerProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        flexibleSpace: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Data Pembayaran',
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
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
          itemCount: pembayaran.length,
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () {
                DetailBottomSheet(
                    context: ctx,
                    pembayaran: pembayaran[index],
                    result: index,
                    lunasButton: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LunasPembayaran(
                                    pembayaran: pembayaran[index],
                                  )));
                    },
                    cetakButton: () async {
                      try {
                        final data = await service.createinvoice(
                            pembayaran: pembayaran[index]);
                        if (!mounted) return;
                        service.savePdfFile(
                            context,
                            "Pembayaran ${pembayaran[index].namaSiswa} ${DateFormat.yMMMMEEEEd('id').format(DateTime.now())}.pdf",
                            data);
                      } catch (e) {
                        Logger().i(e.toString());
                      }
                    });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width: 150,
                                  child: Text(
                                    pembayaran[index].namaSiswa.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  )),
                              const SizedBox(height: 5.0),
                              Text(
                                pembayaran[index].nisn.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Petugas: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      pembayaran[index].namaPetugas.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: HexColor('204FA1')),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          pembayaran[index].jmlBayar! >= 200000
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
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                pembayaran[index].bulanBayar.toString(),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 5.0),
                              Text(pembayaran[index].tahunBayar.toString(),
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<dynamic> DetailBottomSheet(
      {required BuildContext context,
      required Pembayaran pembayaran,
      required dynamic lunasButton,
      required dynamic cetakButton,
      required dynamic result}) {
    return showMaterialModalBottomSheet(
        context: context,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        // ignore: sized_box_for_whitespace
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height - 80,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detail Pembayaran',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: HexColor('204FA1')),
                        ),
                        Builder(builder: (context) {
                          return IconButton(
                            onPressed: () {
                              showAlignedDialog(
                                  context: context,
                                  builder: _localDialogBuilder,
                                  followerAnchor: Alignment.topRight,
                                  targetAnchor: Alignment.bottomRight,
                                  barrierColor: Colors.transparent);
                            },
                            icon: const Icon(Icons.info_outline_rounded),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    const Text(
                      'Nama Siswa',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      pembayaran.namaSiswa.toString(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'NISN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      pembayaran.nisn.toString(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Bulan Bayar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          pembayaran.bulanBayar.toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          pembayaran.tahunBayar.toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Total Bayar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      NumberFormat.simpleCurrency(locale: 'id-ID', name: 'Rp. ')
                          .format(pembayaran.jmlBayar),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Petugas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      pembayaran.namaPetugas.toString(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Tanggal Transaksi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                        DateFormat.yMMMMEEEEd('id').format(DateTime.tryParse(
                            pembayaran.tglTransaksi.toString())!),
                        style: const TextStyle(fontSize: 16.0)),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    pembayaran.jmlBayar! >= 200000
                        ? Card(
                            color: Colors.greenAccent[100],
                            margin: EdgeInsets.zero,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                              child: Text(
                                'Lunas',
                                style: TextStyle(
                                    color: Colors.green, fontSize: 16.0),
                              ),
                            ))
                        : Card(
                            color: Colors.grey[200],
                            margin: EdgeInsets.zero,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                              child: Text(
                                'Belum Lunas',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 16.0),
                              ),
                            )),
                    const SizedBox(height: 30.0),
                    pembayaran.jmlBayar! >= 200000
                        // ? const SizedBox()
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    backgroundColor: HexColor('204FA1'),
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  onPressed: null,
                                  child: const Text(
                                    'Sudah Lunas',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    backgroundColor: HexColor('204FA1'),
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  onPressed: lunasButton,
                                  child: const Text(
                                    'Lunasi',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)),
                              side: BorderSide(color: HexColor('204FA1')),
                              backgroundColor: Colors.white,
                              foregroundColor: HexColor('204FA1'),
                              padding: const EdgeInsets.all(16.0),
                            ),
                            onPressed: cetakButton,
                            child: const Text(
                              'Cetak Pembayaran',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  WidgetBuilder get _localDialogBuilder {
    return (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: HexColor('EAEBE7'))),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    width: 150,
                    child: const Text(
                        'Berikut adalah detail dari pembayaran yang sudah dilakukan',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Quicksand',
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    };
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:myspp_app/controller/pembayaran_history_controller.dart';

class RiwayatPembayaran extends ConsumerStatefulWidget {
  const RiwayatPembayaran({super.key});

  @override
  ConsumerState<RiwayatPembayaran> createState() => _RiwayatPembayaranState();
}

class _RiwayatPembayaranState extends ConsumerState<RiwayatPembayaran> {
  @override
  void initState() {
    super.initState();
    getAllHistory();
  }

  Future<void> getAllHistory() async {
    await ref.read(pembayaranHistoryControllerProvider.notifier).getHistory();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(pembayaranHistoryControllerProvider);
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
                  'Riwayat Pembayaran',
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
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/img/no_data.svg',
                    width: 250,
                  ),
                  const Text('Tidak ada riwayat pembayaran!')
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              itemCount: history.length,
              itemBuilder: (ctx, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10.0),
                        Text(
                          history[index].namaSiswa.toString(),
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          history[index].nisn.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          NumberFormat.simpleCurrency(
                                  locale: 'id', name: 'Rp. ')
                              .format(history[index].jmlBayar),
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat.yMMMMEEEEd('id').format(
                                  DateTime.tryParse(
                                      history[index].tgl.toString())!),
                              style: TextStyle(
                                  color: HexColor('204FA1'),
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              DateFormat.Hm('id').format(DateTime.tryParse(
                                  history[index].tgl.toString())!),
                              style: TextStyle(
                                  color: HexColor('204FA1'),
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:myspp_app/components/snackbars.dart';
import 'package:myspp_app/controller/pembayaran_controller.dart';
import 'package:myspp_app/model/pembayaran.dart';

class LunasPembayaran extends ConsumerStatefulWidget {
  final Pembayaran pembayaran;
  const LunasPembayaran({super.key, required this.pembayaran});

  @override
  ConsumerState<LunasPembayaran> createState() => _LunasPembayaranState();
}

class _LunasPembayaranState extends ConsumerState<LunasPembayaran> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _totalBayar = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: HexColor('204FA1'),
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Lunasi Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20.0))),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          children: [
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nama Siswa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.pembayaran.namaSiswa.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'NISN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.pembayaran.nisn.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Bulan Bayar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        Text(
                          widget.pembayaran.bulanBayar.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          widget.pembayaran.tahunBayar.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Total Tagihan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      NumberFormat.simpleCurrency(
                        locale: 'id',
                        name: 'Rp. ',
                      ).format(widget.pembayaran.jmlTagihan),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      validator: ((value) {
                        // ignore: unrelated_type_equality_checks
                        if (value!.isEmpty || int.tryParse(value) == 0) {
                          return 'Mohon isi nominal pembayaran!';
                        } else if (int.parse(value) >
                            widget.pembayaran.jmlTagihan!.toInt()) {
                          return 'Nominal pembayaran melebihi tagihan!';
                        }
                        return null;
                      }),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      controller: _totalBayar,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.attach_money_rounded,
                          color: Colors.white,
                        ),
                        errorStyle: const TextStyle(color: Colors.white),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 2)),
                        focusColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2)),
                        labelText: 'Total Bayar',
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 40.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.all(12.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0))),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  Pembayaran pembayaran = Pembayaran(
                                    jmlBayar: int.parse(_totalBayar.text) +
                                        widget.pembayaran.jmlBayar!.toInt(),
                                    namaSiswa: widget.pembayaran.namaSiswa,
                                    nisn: widget.pembayaran.nisn,
                                    emailSiswa: widget.pembayaran.emailSiswa,
                                    bulanBayar: widget.pembayaran.bulanBayar,
                                    tahunBayar: widget.pembayaran.tahunBayar,
                                    namaPetugas: widget.pembayaran.namaPetugas,
                                    tglTransaksi: DateTime.now(),
                                    tglDibuat: widget.pembayaran.tglDibuat,
                                    jmlTagihan: widget.pembayaran.jmlTagihan,
                                  );
                                  await ref
                                      .read(
                                          pembayaranControllerProvider.notifier)
                                      .updateBayar(
                                        context: context,
                                        jmlBayar: int.parse(_totalBayar.text),
                                        jmlTagihan: widget
                                            .pembayaran.jmlTagihan!
                                            .toInt(),
                                        pembayaran: pembayaran,
                                        pid: widget.pembayaran.pid.toString(),
                                      );
                                  if (!mounted) return;
                                  Navigator.of(context)
                                    ..pop()
                                    ..pop();
                                  Snackbars().successSnackbars(
                                      context,
                                      'Berhasil',
                                      'Berhasil Melakukan Pembayaran!');
                                } on FirebaseException catch (e) {
                                  Logger().i(e.message);
                                }
                              }
                            },
                            child: Text(
                              'Bayar',
                              style: TextStyle(
                                  color: HexColor('204FA1'),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/model/pembayaran.dart';

class PembayaranController extends StateNotifier<List<Pembayaran>> {
  PembayaranController() : super([]);

  final db = FirebaseFirestore.instance.collection('pembayaran');

  Future<void> getPembayaran() async {
    var checkPembayaran =
        await db.orderBy('tgl_dibuat', descending: true).get();

    List<Pembayaran> pembayarans =
        checkPembayaran.docs.map((e) => Pembayaran.fromJson(e.data())).toList();
    state = pembayarans;
  }

  Future<void> getPembayaranUser() async {
    var checkPembayaran = await db
        .where('email_siswa',
            isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .orderBy('tgl_dibuat', descending: true)
        .get();

    List<Pembayaran> pembayarans =
        checkPembayaran.docs.map((e) => Pembayaran.fromJson(e.data())).toList();
    state = pembayarans;
  }

  Future<void> tambahPembayaran({
    required BuildContext context,
    required Pembayaran pembayaran,
  }) async {
    final doc = db.doc();
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                backgroundColor: HexColor('204FA1'),
              ),
            ));
    Pembayaran temp = pembayaran.copyWith(
      pid: doc.id,
      jmlBayar: 0,
      tglDibuat: DateTime.now(),
      tglTransaksi: DateTime.now(),
    );
    await doc.set(temp.toJson());
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> updateBayar(
      {required BuildContext context,
      required Pembayaran pembayaran,
      required int jmlTagihan,
      required int jmlBayar,
      required String pid}) async {
    final doc = db.doc(pid);
    Pembayaran temp =
        pembayaran.copyWith(pid: doc.id, jmlTagihan: jmlTagihan - jmlBayar);
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                backgroundColor: HexColor('#4392A4'),
              ),
            ));
    await doc.update(temp.toJson());
    if (!mounted) return;
    Navigator.pop(context);
    final dbHistoryPembayaran =
        FirebaseFirestore.instance.collection('history_pembayaran');
    final docID = dbHistoryPembayaran.doc();
    await docID.set({
      'id_history_pembayaran': docID.id,
      'id_pembayaran': doc.id,
      'nama_siswa': temp.namaSiswa,
      'nisn': temp.nisn,
      'jml_bayar': jmlBayar,
      'email_siswa': temp.emailSiswa,
      'bulan_bayar': temp.bulanBayar,
      'tahun_bayar': temp.tahunBayar,
      'tgl': DateTime.now(),
    });
    await getPembayaran();
  }
}

final pembayaranControllerProvider =
    StateNotifierProvider<PembayaranController, List<Pembayaran>>(
  (ref) => PembayaranController(),
);

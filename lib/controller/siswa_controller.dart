import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/model/siswa.dart';
import 'package:myspp_app/pages/siswa/data_siswa.dart';

class SiswaController extends StateNotifier<List<Siswa>> {
  SiswaController() : super([]);

  final db = FirebaseFirestore.instance.collection('siswa');

  Future<void> getSiswa() async {
    var checkSiswa = await db.get();

    List<Siswa> siswas =
        checkSiswa.docs.map((e) => Siswa.fromJson(e.data())).toList();
    state = siswas;
  }

  Future<void> tambahSiswa(
      {required BuildContext context, required Siswa siswa}) async {
    final doc = db.doc();
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                backgroundColor: HexColor('4392A4'),
              ),
            ));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const DataSiswa()));
    Siswa temp = siswa.copyWith(sid: doc.id);
    await doc.set(temp.toJson());
  }

  Future<void> updateSiswa(
      {required BuildContext context,
      required Siswa siswa,
      required String sid}) async {
    final doc = db.doc(sid);
    Siswa temp = siswa.copyWith(sid: doc.id);
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                backgroundColor: HexColor('#4392A4'),
              ),
            ));
    await doc.update(temp.toJson());
    await getSiswa();
  }

  Future<void> deleteSiswa(
      {required BuildContext context, required String sid}) async {
    final doc = db.doc(sid);
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                backgroundColor: HexColor('4392A4'),
              ),
            ));
    await doc.delete();
    await getSiswa();
  }
}

final siswaControllerProvider =
    StateNotifierProvider<SiswaController, List<Siswa>>(
  (ref) => SiswaController(),
);

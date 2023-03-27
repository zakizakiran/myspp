import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myspp_app/model/pembayaran_history.dart';

class PembayaranHistoryController
    extends StateNotifier<List<PembayaranHistory>> {
  PembayaranHistoryController() : super([]);

  final db = FirebaseFirestore.instance.collection('history_pembayaran');

  Future<void> getHistory() async {
    var checkLog = await db.orderBy('tgl', descending: true).get();

    List<PembayaranHistory> logs =
        checkLog.docs.map((e) => PembayaranHistory.fromJson(e.data())).toList();
    state = logs;
  }

  Future<void> getHistoryUser({required email}) async {
    var checkLog = await db
        .where('email_siswa', isEqualTo: email)
        .orderBy('tgl', descending: true)
        .get();

    List<PembayaranHistory> logs =
        checkLog.docs.map((e) => PembayaranHistory.fromJson(e.data())).toList();
    state = logs;
  }
}

final pembayaranHistoryControllerProvider =
    StateNotifierProvider<PembayaranHistoryController, List<PembayaranHistory>>(
  (ref) => PembayaranHistoryController(),
);

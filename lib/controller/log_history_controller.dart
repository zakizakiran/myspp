import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myspp_app/model/log_history.dart';

class LogHistoryController extends StateNotifier<List<LogHistory>> {
  LogHistoryController() : super([]);

  final db = FirebaseFirestore.instance.collection('log_history');

  Future<void> getLog({required String email}) async {
    var checkLog = await db
        .orderBy('tgl', descending: true)
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    List<LogHistory> logs =
        checkLog.docs.map((e) => LogHistory.fromJson(e.data())).toList();
    state = logs;
  }

  Future<void> deleteAllLog(
      {required BuildContext context, required String email}) async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(
                backgroundColor: HexColor('4392A4'),
              ),
            ));
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var collection = instance
        .collection('log_history')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
    await getLog(email: email);
  }
}

final logHistoryControllerProvider =
    StateNotifierProvider<LogHistoryController, List<LogHistory>>(
  (ref) => LogHistoryController(),
);

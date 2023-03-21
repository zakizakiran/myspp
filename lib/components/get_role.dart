import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class RoleName {
  static List roleName = [];
  Future<List> chooseRole() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('roles').get();
      List<List> data =
          snapshot.docs.map((e) => e.data().values.first).toList().cast<List>();

      data.map((e) => e.map((e2) => roleName.add(e2)).toList()).toList();
    } catch (e) {
      Logger().e(e);
    }
    return roleName;
  }
}

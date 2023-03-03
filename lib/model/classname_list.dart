import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class Classname {
  static List className = [];
  static List gradeName = [];
  static List test = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  Future<List> chooseClass() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('classgrade').get();
      List<List> data =
          snapshot.docs.map((e) => e.data().values.first).toList().cast<List>();

      data.map((e) => e.map((e2) => className.add(e2)).toList()).toList();
    } catch (e) {
      Logger().e(e);
    }
    return className;
  }

  Future<List> getGrade() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('classgrade').get();
      List data = snapshot.docs.map((e) => e.data().values.last).toList();
      data.map((e) => gradeName.add(e)).toList();
    } catch (e) {
      Logger().e(e);
    }
    return gradeName;
  }
}

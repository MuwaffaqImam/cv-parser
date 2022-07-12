import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvparser_b21_01/datatypes/report.dart';
import 'package:get/get.dart';

class Reports extends GetxService {
  final FirebaseFirestore db;
  late final CollectionReference reports = db.collection('reports');

  Reports(this.db);

  Future<void> makeReport(Report data) async {
    await reports.add(data.toJson());
  }
}

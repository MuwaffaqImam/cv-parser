import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvparser_b21_01/services/reports.dart';

import '../services/file_saver.dart';
import '../services/i_extract.dart';
import '../services/key_listener.dart';
import '../services/pdf_to_text.dart';
import 'package:get/get.dart';

class ServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IExtract());
    Get.put(PdfToText());
    Get.put(KeyListener());
    Get.put(FileSaver());
    Get.put(Reports(FirebaseFirestore.instance));
  }
}

import 'dart:typed_data';

import 'package:file_saver/file_saver.dart' as file_saver_extension;
import 'package:get/get.dart';

class FileSaver extends GetxService {
  Future<void> saveJsonFile({
    required String name,
    required Uint8List bytes,
  }) async {
    await file_saver_extension.FileSaver.instance.saveFile(
      name,
      bytes,
      "json",
      mimeType: file_saver_extension.MimeType.JSON,
    );
  }
}

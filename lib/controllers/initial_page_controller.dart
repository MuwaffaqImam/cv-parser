import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/views/dialogs/fail_dialog.dart';
import 'package:cvparser_b21_01/views/dialogs/process_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';

class InitialPageController extends GetxController {
  late DropzoneViewController dropzoneController;

  final isDropzoneHovered = false.obs;

  void gotoMain(List<RawPdfCV> cvs) async {
    // parse first
    Get.dialog(
      const ProcessDialog(
        titleText: "Redirecting",
        details: "please wait ...",
      ),
      barrierDismissible: false, // make it blocking
    );
    try {
      await cvs[0].parse();
    } catch (e) {
      Get.back();
      Get.dialog(
        const FailDialog(
          titleText: "File parsing failed",
          details: "failed to parse the first file",
        ),
      );
      return;
    }
    Get.back();

    // goto
    Get.toNamed(
      "/main",
      arguments: cvs,
      parameters: Get.parameters.map(
        (key, value) => MapEntry(
          key,
          value.toString(),
        ),
      ),
    );
  }

  void instantiateDropzoneController(DropzoneViewController ctrl) {
    dropzoneController = ctrl;
  }

  void onDropFiles(List<dynamic>? fhs) async {
    if (fhs != null) {
      List<RawPdfCV> cvs = [];
      for (final fh in fhs) {
        if (fh.name.toString().endsWith(".pdf")) {
          cvs.add(
            RawPdfCV(
              filename: fh.name,
              readStream: dropzoneController.getFileStream(fh),
              size: await dropzoneController.getFileSize(fh),
            ),
          );
        }
      }

      if (cvs.isEmpty) {
        Get.dialog(
          const FailDialog(
            titleText: "File uploading failed",
            details: "please provide at least one pdf file",
          ),
        );
        return;
      }

      gotoMain(cvs);
    }
  }

  void onDropzoneHover() {
    isDropzoneHovered.value = true;
  }

  void onDropzoneLeave() {
    isDropzoneHovered.value = false;
  }

  void uploadFilesManually() async {
    // select files blocking popup
    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"], // TESTIT: what if not pdf
      allowMultiple: true,
      withReadStream: true,
      withData: false,
      lockParentWindow: true,
    );

    // get files
    if (picked != null) {
      List<RawPdfCV> cvs = [];

      for (PlatformFile file in picked.files) {
        cvs.add(
          RawPdfCV(
            filename: file.name,
            readStream: file.readStream!,
            size: file.size,
          ),
        );
      }

      gotoMain(cvs);
    }
  }
}

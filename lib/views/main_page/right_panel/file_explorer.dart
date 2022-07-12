import 'package:should_rebuild/should_rebuild.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'file_explorer/pdf_icon_button.dart';

// TODO: add/remove element animations
class FileExplorer extends GetView<MainPageController> {
  final keyLookup = Get.find<KeyListener>();

  FileExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final filteredCvs = controller.filteredCvs;
        return GridView.builder(
          itemCount: filteredCvs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final tile = filteredCvs[index];
            return ShouldRebuild<PdfIconButton>(
              shouldRebuild: (oldWidget, newWidget) =>
                  oldWidget.filename != newWidget.filename ||
                  oldWidget.isSelected != newWidget.isSelected ||
                  oldWidget.isParsed != newWidget.isParsed,
              child: PdfIconButton(
                index: tile.index,
                isSelected: tile.item.isSelected,
                filename: tile.item.item.filename,
                isParsed: tile.item.item.isParseCachedComplete(),
              ),
            );
          },
        );
      },
    );
  }
}

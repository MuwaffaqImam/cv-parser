import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBar extends GetView<MainPageController> {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 25.0),
        TextField(
          onSubmitted: controller.updateFileExplorerQuery,
          style: const TextStyle(color: colorTextSmoothBlack),
          cursorColor: colorTextSmoothBlack,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: colorPrimaryRedCaramel, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide:
                  const BorderSide(color: colorPrimaryRedCaramel, width: 1),
            ),
            hintText: "Search...",
            hintStyle: const TextStyle(color: colorTextSmoothBlack),
            prefixIcon: const Icon(Icons.search, color: colorTextSmoothBlack),
            constraints: const BoxConstraints(maxHeight: 40, maxWidth: 450),
            contentPadding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}

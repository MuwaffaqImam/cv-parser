import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'parse_result/card_widget.dart';

class ParseResult extends GetView<MainPageController> {
  const ParseResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<Widget> content = [];
        if (controller.current != null) {
          for (var entry in controller.current!.data.entries) {
            content.add(
              CardWidget(
                title: entry.key,
                elements: entry.value,
                onMakeReportRequested: (match) =>
                    controller.makeReport(match, entry.key),
              ),
            );
          }
        } else {
          content.add(
            Container(
              width: 1350,
              height: 100,
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "[ no results ]",
                  style: TextStyle(
                    fontSize: 52,
                    fontFamily: "Eczar",
                    fontWeight: FontWeight.w400,
                    color: colorTextSmoothBlack,
                  ),
                ),
              ),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: content,
          ),
        );
      },
    );
  }
}

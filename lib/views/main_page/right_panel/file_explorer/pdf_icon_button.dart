import 'dart:math';

import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:cvparser_b21_01/services/key_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:cvparser_b21_01/views/tooltip.dart' as my_tooltip;

class PdfIconButton extends StatefulWidget {
  final int index;
  final bool isSelected;
  final String filename;
  final bool isParsed;

  const PdfIconButton({
    Key? key,
    required this.index,
    required this.isSelected,
    required this.filename,
    required this.isParsed,
  }) : super(key: key);

  @override
  State<PdfIconButton> createState() => _PdfIconButtonState();
}

class _PdfIconButtonState extends State<PdfIconButton> {
  final controller = Get.find<MainPageController>();
  final keyLookup = Get.find<KeyListener>();

  var hovered = false;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decor = widget.isSelected
        ? BoxDecoration(
            color: const Color.fromARGB(40, 77, 102, 88),
            border: Border.all(color: const Color.fromARGB(255, 174, 73, 33)),
          )
        : BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            border: Border.all(
              color: const Color.fromARGB(20, 77, 102, 88),
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            hovered = false;
          });
        },
        child: GestureDetector(
          onPanDown: (d) {
            if (keyLookup.shift) {
              // range select
              controller.selectPoint ??= 0;
              final start = min(controller.selectPoint!, widget.index);
              final stop = max(controller.selectPoint!, widget.index);
              for (int i = start; i <= stop; i++) {
                controller.select(i);
              }
            } else {
              // single select
              if (!keyLookup.ctrl) {
                controller.deselectAll();
              }
              controller.switchSelect(widget.index);
            }
            controller.selectPoint = widget.index;
          },
          onTap: () {
            controller.setCurrent(widget.index);
          },
          child: my_tooltip.Tooltip(
            message: widget.filename,
            child: Container(
              decoration: decor.copyWith(
                color: hovered ? const Color.fromARGB(10, 218, 225, 226) : null,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "icons/icon.svg",
                          width: 60,
                          height: 69,
                          color: colorSecondaryGreenPlant,
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                            child: Opacity(
                              opacity: widget.isParsed ? 0.0 : 0.6,
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      widget.filename,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: colorTextSmoothBlack),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

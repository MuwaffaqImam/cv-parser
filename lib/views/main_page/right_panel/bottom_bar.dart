import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomBar extends GetView<MainPageController> {
  const BottomBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int c = 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.onSurface),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.primary, width: 2),
                )),
                fixedSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
              ),
              onPressed: controller.exportSelected,
              child: const Text("EXPORT SELECTED AS JSON",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size(50, 50)),
                ),
                onPressed: () => {
                      c == 0 ? controller.selectParsed() : null,
                      c == 1 ? controller.invertSelection() : null,
                      c == 2 ? controller.selectAll() : null,
                      c == 2 ? c = 0 : c++
                    },
                child: Icon(Icons.library_add_check,
                    color: Theme.of(context).colorScheme.onSurface)),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                fixedSize: MaterialStateProperty.all<Size>(const Size(50, 50)),
              ),
              onPressed: controller.deleteSelected,
              child: Icon(Icons.delete_outline,
                  color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        const SizedBox(height: 18.0),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onSurface),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 24,
                fontFamily: "Merriweather",
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              side: BorderSide(
                  color: Theme.of(context).colorScheme.primary, width: 2),
              borderRadius: BorderRadius.circular(10),
            )),
            fixedSize: MaterialStateProperty.all<Size>(const Size(340, 50)),
          ),
          onPressed: controller.askUserToUploadPdfFiles,
          child: const Text("UPLOAD MORE"),
        ),
      ],
    );
  }
}

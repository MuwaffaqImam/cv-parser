import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Footer extends GetView<MainPageController> {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1350,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 2, 5, 0),
        child: Obx(
          () => controller.current == null
              ? const Center(
                  child: Text(
                    "nothing selected",
                    style: TextStyle(
                      height: 1.3,
                      fontSize: 40,
                      fontFamily: "Eczar",
                      fontWeight: FontWeight.w400,
                      color: colorTextSmoothBlack,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          controller.current!.filename,
                          style: TextStyle(
                            height: 1.3,
                            fontSize: MediaQuery.of(context).size.width / 50,
                            fontFamily: "Eczar",
                            fontWeight: FontWeight.w400,
                            color: colorTextSmoothBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onSurface),
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(250, 35)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2),
                          )),
                        ),
                        onPressed: controller.exportCurrent,
                        child: Text("EXPORT AS JSON",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Merriweather',
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

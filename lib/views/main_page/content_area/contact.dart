import 'package:cvparser_b21_01/colors.dart';
import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Contact extends GetView<MainPageController> {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Flexible(
          child: SizedBox(
        width: (MediaQuery.of(context).size.width > 1400) ? 495 : 365,
        height: 120,
        child: Row(
          children: [
            Container(
                width: 365,
                height: 110,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.current?.data['PERSON']?[0].match ??
                            'no name',
                        style: const TextStyle(
                          height: 1,
                          fontSize: 30,
                          fontFamily: "Eczar",
                          fontWeight: FontWeight.w400,
                          color: colorTextSmoothBlack,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        controller.current?.data['emails']?[0].match ??
                            'no email',
                        style: const TextStyle(
                          height: 1,
                          fontSize: 18,
                          fontFamily: "Eczar",
                          fontWeight: FontWeight.w400,
                          color: colorTextSmoothBlack,
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ])),
            if (MediaQuery.of(context).size.width > 1400)
              const SizedBox(width: 20, height: 110),
            if (MediaQuery.of(context).size.width > 1400)
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.account_circle_outlined,
                    size: 80, color: Theme.of(context).colorScheme.primary),
              ),
          ],
        ),
      ));
    });
  }
}

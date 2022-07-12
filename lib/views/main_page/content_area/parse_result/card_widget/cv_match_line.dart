import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class CVMatchLine extends StatelessWidget {
  final String match;
  final bool reported;
  final VoidCallback? onMakeReportRequested;

  const CVMatchLine({
    Key? key,
    required this.match,
    required this.reported,
    this.onMakeReportRequested,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorSecondaryLightGreenPlant,
      shadowColor: Colors.transparent,
      child: Column(children: [
        SizedBox(
          width: 1300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  match,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Merriweather',
                    color: colorTextSmoothBlack,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextButton(
                  onPressed: () {
                    if (onMakeReportRequested != null) {
                      onMakeReportRequested!();
                    }
                  },
                  child: const Text('report'),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          color: const Color.fromARGB(35, 77, 102, 88),
          margin: const EdgeInsets.fromLTRB(0, 20, 30, 10),
        ),
      ]),
    );
  }
}

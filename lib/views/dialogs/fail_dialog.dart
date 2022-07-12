import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class FailDialog extends StatelessWidget {
  final String titleText;
  final String details;

  const FailDialog({
    Key? key,
    required this.titleText,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 5,
          width: MediaQuery.of(context).size.width / 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                titleText,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 60,
                  fontFamily: "Eczar",
                  fontWeight: FontWeight.w400,
                  color: colorTextSmoothBlack,
                ),
              ),
              Flexible(
                child: Text(
                  details,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 75,
                    fontWeight: FontWeight.w400,
                    color: colorTextSmoothBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

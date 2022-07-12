import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class ProgressDone {
  final double? percentage; // 0 - 1
  final String comments;
  ProgressDone(this.percentage, this.comments);
}

class ProgressDialog extends StatelessWidget {
  final String titleText;
  final Stream<ProgressDone> progressStream;

  const ProgressDialog({
    Key? key,
    required this.titleText,
    required this.progressStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: StreamBuilder(
        stream: progressStream,
        builder: (context, snapshot) {
          final data = snapshot.data as ProgressDone;
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
                    Center(
                      child: CircularProgressIndicator(
                        value: data.percentage,
                      ),
                    ),
                    Flexible(
                        child: Text(
                      data.comments,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 75,
                        fontWeight: FontWeight.w400,
                        color: colorTextSmoothBlack,
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

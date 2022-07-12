import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class ReportDialog extends StatelessWidget {
  final void Function(String text) onTextSubmitted;

  const ReportDialog({
    Key? key,
    required this.onTextSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          color: colorPrimaryLightRedCaramel,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Please provide a comment",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 60,
                    fontFamily: "Eczar",
                    fontWeight: FontWeight.w400,
                    color: colorTextSmoothBlack,
                  ),
                ),
                TextField(
                  onSubmitted: onTextSubmitted,
                  style: const TextStyle(color: colorTextSmoothBlack),
                  cursorColor: colorTextSmoothBlack,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: colorPrimaryRedCaramel, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: colorPrimaryRedCaramel, width: 3),
                    ),
                    hintText: "Text...",
                    hintStyle: const TextStyle(color: colorTextSmoothBlack),
                    constraints: const BoxConstraints(
                      maxHeight: 400,
                      maxWidth: 450,
                    ),
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cvparser_b21_01/colors.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '                       iExtract',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Eczar',
              fontWeight: FontWeight.w600,
              color: colorPrimaryRedCaramelDark,
              height: 0.9,
            ),
          ),
          Text(
            'CVParser',
            style: TextStyle(
              fontSize: 56,
              fontFamily: 'Eczar',
              fontWeight: FontWeight.w600,
              color: colorPrimaryRedCaramelDark,
              height: 0.7,
            ),
          )
        ],
      ),
    );
  }
}

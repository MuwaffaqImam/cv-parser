import 'package:cvparser_b21_01/views/main_page/content_area.dart';
import 'package:cvparser_b21_01/views/main_page/right_panel.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width - 500,
              height: MediaQuery.of(context).size.height,
              child: const ContentArea()),
          SizedBox(
              width: 500,
              height: MediaQuery.of(context).size.height,
              child: const RightPanel()),
        ],
      ),
    );
  }
}

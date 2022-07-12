import 'package:flutter/material.dart';

import 'right_panel/bottom_bar.dart';
import 'right_panel/file_explorer.dart';
import 'right_panel/top_bar.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      width: 500,
      color: Theme.of(context).colorScheme.onSurface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const TopBar(),
          const SizedBox(height: 18.0),
          Expanded(child: FileExplorer()),
          const SizedBox(height: 18.0),
          const BottomBar(),
        ],
      ),
    );
  }
}

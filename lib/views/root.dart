import 'package:cvparser_b21_01/views/notifications_overlay.dart';
import 'package:flutter/material.dart';

class ApplicationRoot extends StatelessWidget {
  final Widget child;

  const ApplicationRoot({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const NotificationsOverlay(),
      ],
    );
  }
}

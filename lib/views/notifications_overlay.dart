import 'package:cvparser_b21_01/controllers/notifications_overlay_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notifications_overlay/notification_card.dart';

// TODO: add/remove element animations
class NotificationsOverlay extends GetView<NotificationsOverlayController> {
  const NotificationsOverlay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 490,
      height: 195,
      child: Obx(
        () => ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: controller.entries
              .map(
                (e) => NotificationCard(
                  key: ValueKey(e.key),
                  msg: e.value,
                  onClose: () => controller.close(e.key),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

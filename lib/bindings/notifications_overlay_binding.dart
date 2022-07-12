import 'package:cvparser_b21_01/controllers/notifications_overlay_controller.dart';
import 'package:get/get.dart';

class NotificationsOverlayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationsOverlayController());
  }
}

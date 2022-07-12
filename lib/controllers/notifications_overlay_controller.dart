import 'package:get/get.dart';

class NotificationsOverlayController extends GetxController {
  final notifications = <int, String>{}.obs; // unique id -> String msg
  var latest = 0;

  List<MapEntry<int, String>> get entries =>
      notifications.entries.toList().reversed.toList();

  void close(int id) {
    notifications.remove(id);
  }

  void notify(String msg) {
    notifications[latest] = msg;
    latest++;
  }
}

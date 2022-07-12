import 'package:cvparser_b21_01/controllers/initial_page_controller.dart';
import 'package:get/get.dart';

class InitialPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InitialPageController());
  }
}

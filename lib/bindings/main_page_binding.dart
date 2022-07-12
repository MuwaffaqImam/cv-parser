import 'package:cvparser_b21_01/controllers/main_page_controller.dart';
import 'package:get/get.dart';

class MainPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainPageController());
  }
}

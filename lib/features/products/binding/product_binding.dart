import 'package:get/get.dart';

import '../viewmodel/products_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductController());
  }
}

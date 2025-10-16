import 'package:get/get.dart';

import '../viewmodel/products_controller.dart';


class ProductBinding extends Bindings {
  @override
  void dependencies() {
    // هنا نربط الكنترولر بحيث يشتغل أول ما نفتح الصفحة
    Get.put(ProductController());
  }
}

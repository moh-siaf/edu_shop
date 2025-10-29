import 'package:get/get.dart';
import '../../admin/viewmodel/manage_offers_controller.dart';
import '../../cart/cart_controller/cart_controller.dart';
import '../../categories/viewmodel/category_controller.dart';
import '../../offers/viewmodel/offers_controller.dart';
import '../viewmodel/products_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => CategoryController(), fenix: true);
    Get.lazyPut(() => ManageOffersController());
  }
}

// --- في ملف: lib/features/admin/categories/view/pages/add_category_binding.dart ---

import 'package:get/get.dart';
import '../../admin/viewmodel/manage_categories_controller.dart';
import '../../offers/viewmodel/offers_controller.dart';
import '../viewmodel/ManageProductsController.dart';
import '../viewmodel/manage_discounts_controller.dart';
import '../viewmodel/manage_offers_controller.dart';

class AddCategoryBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ManageCategoriesController>(() => ManageCategoriesController());
    Get.lazyPut(() => ManageOffersController());
    Get.lazyPut(() => ManageDiscountsController());
    Get.lazyPut(() => OffersController());
    Get.lazyPut(() => ManageProductsController());
  }
}

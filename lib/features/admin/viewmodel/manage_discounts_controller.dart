// --- في ملف: lib/features/admin/viewmodel/manage_discounts_controller.dart ---

import 'package:get/get.dart';

// ✅ 1. استيراد الواجهة وليس التنفيذ
import '../../../data/repositories/base_product_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../model/product_model.dart';
import '../../offers/viewmodel/offers_controller.dart';

class ManageDiscountsController extends GetxController {
  // ✅ 2. الاعتماد على الواجهة
  final BaseProductRepository _productRepo = ProductRepository();

  final OffersController _offersController = Get.find<OffersController>();

  RxList<ProductModel> get discountedProducts => _offersController.discountedProducts;
  final isUpdating = false.obs;

  Future<bool> setProductDiscount({
    required String productId,
    required int discountPercentage,
  }) async {
    isUpdating.value = true;
    try {
      final ProductModel? product = await _productRepo.getProductById(productId);
      if (product == null) throw Exception('المنتج غير موجود!');

      final double newPrice = product.price * (1 - (discountPercentage / 100));

      // ✅ 3. استدعاء الدالة من الواجهة
      await _productRepo.updateProductDiscount(
        productId: productId,
        discountPercentage: discountPercentage,
        newPrice: newPrice,
      );

      await _offersController.fetchAllOffersData();
      Get.snackbar('نجاح', 'تم حفظ الخصم بنجاح.');
      return true;
    } catch (e) {
      Get.snackbar('فشل', 'حدث خطأ أثناء حفظ الخصم.');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> removeProductDiscount(String productId) async {
    isUpdating.value = true;
    try {
      // ✅ 4. استدعاء الدالة من الواجهة
      await _productRepo.removeProductDiscount(productId);

      await _offersController.fetchAllOffersData();
      Get.snackbar('نجاح', 'تم إزالة الخصم.');
    } catch (e) {
      Get.snackbar('فشل', 'حدث خطأ أثناء إزالة الخصم.');
    } finally {
      isUpdating.value = false;
    }
  }
}

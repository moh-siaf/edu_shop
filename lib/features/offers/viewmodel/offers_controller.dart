// --- في ملف: lib/features/offers/viewmodel/offers_controller.dart ---

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/product_model.dart';
import '../model/offer_model.dart'; // ✅ استيراد مودل المنتج

class OffersController extends GetxController {
  // --- ✅ متغيرات للحالتين ---
  final generalOffers = <OfferModel>[].obs; // للعروض العامة (البانرات)
  final discountedProducts = <ProductModel>[].obs; // للمنتجات المخفضة

  final isLoading = true.obs;
  final isError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllOffersData();
  }

  /// ✅ دالة واحدة لجلب كل بيانات العروض
  Future<void> fetchAllOffersData() async {
    try {
      isLoading.value = true;
      isError.value = false;

      // --- جلب البيانات بالتوازي لتحسين الأداء ---
      final results = await Future.wait([
        _fetchGeneralOffers(),
        _fetchDiscountedProducts(),
      ]);

      // --- تحديث القوائم بعد جلب البيانات ---
      generalOffers.assignAll(results[0] as List<OfferModel>);
      discountedProducts.assignAll(results[1] as List<ProductModel>);

    } catch (e) {
      isError.value = true;
      print("خطأ في جلب بيانات العروض: $e");
      Get.snackbar('خطأ', 'فشل تحميل البيانات. يرجى التحقق من اتصالك بالإنترنت.');
    } finally {
      isLoading.value = false;
    }
  }

  // دالة فرعية لجلب العروض العامة
  Future<List<OfferModel>> _fetchGeneralOffers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('offers')
        .get();
    return querySnapshot.docs.map((doc) => OfferModel.fromDoc(doc)).toList();
  }

  // دالة فرعية لجلب المنتجات المخفضة
  Future<List<ProductModel>> _fetchDiscountedProducts() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('discountPrice', isGreaterThan: 0) // الشرط الأساسي
        .get();
    return querySnapshot.docs.map((doc) => ProductModel.fromDoc(doc)).toList();
  }
}

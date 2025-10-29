// --- في ملف: lib/features/admin/products/viewmodel/manage_products_controller.dart ---

import 'dart:io';
import 'package:get/get.dart';

import '../../../../data/repositories/base_product_repository.dart';
import '../../../../data/repositories/product_repository.dart';
import '../../../../data/repositories/storage_repository.dart';
import '../../../../model/product_model.dart';
import '../../products/viewmodel/products_controller.dart';

class ManageProductsController extends GetxController {
  // --- المستودعات (موجودة سابقًا) ---
  final BaseProductRepository _repo = ProductRepository();
  final BaseStorageRepository _storageRepo = StorageRepository();

  // --- متغيرات الحالة (موجودة سابقًا) ---
  final isLoading = false.obs;

  // --- ✅ [جديد]: قائمة لتخزين منتجات القسم المحدد ---
  final RxList<ProductModel> categoryProducts = <ProductModel>[].obs;
  String? _lastFetchedCategoryId;

  // --- ✅ [جديد]: دالة لجلب المنتجات حسب القسم ---
  Future<void> fetchProductsByCategory(String categoryId) async {
    if (isLoading.value || _lastFetchedCategoryId == categoryId) return;

    isLoading.value = true;
    _lastFetchedCategoryId = categoryId;

    try {
      // استدعاء دالة جديدة من المستودع (سنضيفها لاحقًا)
      final products = await _repo.getProductsByCategoryId(categoryId);
      categoryProducts.assignAll(products);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تحميل المنتجات: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // --- دوال الإدارة (موجودة سابقًا) ---

  Future<void> addProduct(ProductModel product) async {
    isLoading.value = true;
    try {
      await _repo.addProduct(product);
      Get.find<ProductController>().fetchProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    isLoading.value = true;
    try {
      await _repo.updateProduct(product);
      Get.find<ProductController>().fetchProducts();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    await _repo.deleteProduct(id);
    // ✅ تحسين: إزالة المنتج من القائمة المحلية فورًا
    categoryProducts.removeWhere((product) => product.id == id);
    Get.find<ProductController>().fetchProducts(); // تحديث قائمة العميل
  }

  Future<String?> pickAndUploadImage(File file) async {
    isLoading.value = true;
    try {
      final url = await _storageRepo.uploadProductImage(file);
      return url;
    } finally {
      isLoading.value = false;
    }
  }

  // --- دالة لتنظيف القائمة عند الخروج من الصفحة ---
  @override
  void onClose() {
    categoryProducts.clear();
    _lastFetchedCategoryId = null;
    super.onClose();
  }
}

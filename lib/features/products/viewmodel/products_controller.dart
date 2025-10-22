import 'package:get/get.dart';
import 'dart:io';

import '../../../data/repositories/base_product_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../model/product_model.dart';

class ProductController extends GetxController {
  final BaseProductRepository _repo = ProductRepository();
  final BaseStorageRepository _storageRepo = StorageRepository();

  final products = <ProductModel>[].obs;
  final isLoading = false.obs;

  /// 🔹 تحميل كل المنتجات من المستودع
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      // 1. جلب البيانات من المستودع
      final data = await _repo.getAllProducts();

      // --- 💡 الكود التشخيصي المضاف ---





      // --- نهاية التشخيص ---

      // 2. تحديث قائمة المنتجات
      products.assignAll(data);

    } catch (e) {
      // طباعة أي خطأ يحدث أثناء جلب البيانات

    } finally {
      isLoading.value = false;
    }
  }

  ProductModel? getById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addProduct(ProductModel product) async {
    await _repo.addProduct(product);
    fetchProducts();
  }

  Future<String?> pickAndUploadImage(File file) async {
    final url = await _storageRepo.uploadProductImage(file);
    return url;
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _repo.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      Get.snackbar('تم الحذف', 'تم حذف المنتج بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر حذف المنتج');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _repo.updateProduct(product);
      final index = products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        products[index] = product;
        products.refresh();
      }
      Get.snackbar('تم التعديل', 'تم تحديث المنتج بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر تعديل المنتج');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
}

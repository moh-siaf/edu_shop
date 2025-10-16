import 'package:get/get.dart';
import 'dart:io';

import '../../../data/repositories/base_product_repository.dart';

import '../../../data/repositories/product_repository.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../model/product_model.dart';


/// 🎮 هذا الكنترولر لا يعرف Firebase إطلاقًا.
/// يتعامل فقط مع واجهات مجردة (BaseProductRepository و BaseStorageRepository)
class ProductController extends GetxController {
  final BaseProductRepository _repo = ProductRepository();
  final BaseStorageRepository _storageRepo = StorageRepository();

  // 📦 قائمة المنتجات
  final products = <ProductModel>[].obs;

  // 🔄 حالة التحميل
  final isLoading = false.obs;

  /// 🔹 تحميل كل المنتجات من المستودع
  Future<void> fetchProducts() async {
    isLoading.value = true;
    final data = await _repo.getAllProducts();
    products.assignAll(data);
    isLoading.value = false;
  }

  /// 🔹 جلب منتج محدد من القائمة الحالية
  ProductModel? getById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 🔹 إضافة منتج جديد عبر المستودع
  Future<void> addProduct(ProductModel product) async {
    await _repo.addProduct(product);
    fetchProducts(); // تحديث القائمة بعد الإضافة
  }

  /// 🔹 رفع الصورة واسترجاع رابطها من مستودع التخزين
  Future<String?> pickAndUploadImage(File file) async {
    final url = await _storageRepo.uploadProductImage(file);
    return url;
  }


  /// 🔹 تحميل المنتجات عند بدء التشغيل
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }
}

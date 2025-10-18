import 'package:get/get.dart';

import '../../../data/repositories/BaseCategoryRepository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../model/category_model.dart';
import '../../../model/product_model.dart';

/// 🎮 هذا الكنترولر لا يعرف Firebase إطلاقًا.
/// يتعامل فقط مع BaseCategoryRepository.
class CategoryController extends GetxController {
  final BaseCategoryRepository _repo = CategoryRepository();
  final categories = <CategoryModel>[].obs;
  final bestSellers = <ProductModel>[].obs;
  final recommended = <ProductModel>[].obs;
  final isLoading = false.obs;



  /// 🔹 تحميل كل الفئات من المستودع
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final data = await _repo.getAllCategories();
      categories.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 إضافة فئة جديدة
  Future<void> addCategory(CategoryModel category) async {
    try {
      await _repo.addCategory(category);
      await fetchCategories(); // تحديث القائمة
      Get.snackbar('تمت الإضافة', 'تمت إضافة الفئة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر إضافة الفئة: $e');
    }
  }

  /// 🔹 تعديل فئة موجودة
  Future<void> updateCategory(CategoryModel category) async {
    try {
      await _repo.updateCategory(category);
      await fetchCategories();
      Get.snackbar('تم التحديث', 'تم تعديل الفئة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر تعديل الفئة: $e');
    }
  }

  /// 🔹 حذف فئة
  Future<void> deleteCategory(String id) async {
    try {
      await _repo.deleteCategory(id);
      categories.removeWhere((c) => c.id == id);
      Get.snackbar('تم الحذف', 'تم حذف الفئة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', 'تعذر حذف الفئة: $e');
    }
  }

  /// 🔹 تحميل الفئات عند بدء التشغيل
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}

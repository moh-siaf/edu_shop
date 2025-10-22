import 'package:get/get.dart';

import '../../../data/repositories/BaseCategoryRepository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../model/category_model.dart';

class CategoryController extends GetxController {
  // 1. حقن الـ Repository (نستخدم Base لضمان العزل)
  final BaseCategoryRepository _repository = CategoryRepository();

  // 2. متغيرات الحالة التي ستراقبها الواجهة
  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;

  // 3. دالة لجلب كل الأقسام
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      final data = await _repository.getAllCategories();
      categories.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  // 4. دالة لإضافة قسم جديد
  Future<void> addCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      await _repository.addCategory(category);
      fetchCategories(); // إعادة تحميل القائمة بعد الإضافة
    } finally {
      isLoading.value = false;
    }
  }

  // 5. دالة لتحديث قسم موجود
  Future<void> updateCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      await _repository.updateCategory(category);
      // تحديث العنصر في القائمة المحلية لتجنب إعادة تحميل الكل
      final index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = category;
        categories.refresh();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // 6. دالة لحذف قسم
  Future<void> deleteCategory(String categoryId) async {
    try {
      isLoading.value = true;
      await _repository.deleteCategory(categoryId);
      // حذف العنصر من القائمة المحلية
      categories.removeWhere((c) => c.id == categoryId);
    } finally {
      isLoading.value = false;
    }
  }
  // في ملف category_controller.dart

  CategoryModel? getById(String id) {
    try {
      // ابحث في قائمة الأقسام عن القسم الذي يطابق الـ ID
      return categories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      // إذا لم يتم العثور عليه، أرجع null بأمان
      return null;
    }
  }


  // 7. جلب الأقسام تلقائيًا عند بدء تشغيل الكنترولر
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}

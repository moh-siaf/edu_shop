import 'dart:io';

import 'package:get/get.dart';

import '../../../data/repositories/BaseCategoryRepository.dart';
import '../../../data/repositories/base_product_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../model/category_model.dart';

class CategoryController extends GetxController {
  // 1. حقن الـ Repository (نستخدم Base لضمان العزل)
  final BaseCategoryRepository _repository = CategoryRepository();
  final BaseStorageRepository _storageRepo = StorageRepository();
  final isAdding = false.obs;

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
  /// ترفع صورة القسم وتعيد الرابط الخاص بها.
  Future<String?> uploadCategoryImage(File file) async {
    try {
      final imageUrl = await _storageRepo.uploadProductImage(file);
      return imageUrl;
    } catch (e) {
      Get.snackbar('خطأ في الرفع', 'فشلت عملية رفع الصورة.');
      print('Error uploading category image: $e');
      return null;
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

  // --- في category_controller.dart ---

  /// ينسق عملية إنشاء قسم جديد: يرفع الصورة ثم يحفظ البيانات.
  Future<void> createCategory({
    required String name,
    required File imageFile,
  }) async {
    try {
      isLoading.value = true;

      // 1. رفع الصورة
      final imageUrl = await uploadCategoryImage(imageFile);
      if (imageUrl == null) throw Exception('فشل رفع الصورة.');

      // 2. تجهيز المودل
      final newCategory = CategoryModel(id: '', name: name, imageUrl: imageUrl);


      await addCategory(newCategory);

      Get.back(); // العودة بعد النجاح
      Get.snackbar('نجاح', 'تم إضافة القسم بنجاح.');

    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    } finally {
      isLoading.value = false;
    }
  }



  // 7. جلب الأقسام تلقائيًا عند بدء تشغيل الكنترولر
  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }
}

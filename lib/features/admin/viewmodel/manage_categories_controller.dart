// --- في ملف: lib/features/admin/categories/viewmodel/manage_categories_controller.dart ---

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/repositories/BaseCategoryRepository.dart';
import '../../../../data/repositories/category_repository.dart';
import '../../../../data/repositories/storage_repository.dart';
import '../../../../model/category_model.dart';
import '../../../data/repositories/base_product_repository.dart';
import '../../categories/viewmodel/category_controller.dart';

class ManageCategoriesController extends GetxController {
  final BaseCategoryRepository _repo = CategoryRepository();
  final BaseStorageRepository _storageRepo = StorageRepository();

  final isLoading = false.obs;
  // ✅ المتغير التفاعلي لإدارة الصورة المختارة
  final selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // ✅ دالة اختيار الصورة
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // ✅ دالة لمسح الصورة عند الخروج من الصفحة
  void clearImage() {
    selectedImage.value = null;
  }


  // --- دوال الإدارة المنقولة (بدون عناصر واجهة) ---

  Future<void> addCategory(CategoryModel category) async {
    isLoading.value = true;
    try {
      await _repo.addCategory(category);
      Get.find<CategoryController>().fetchCategories(); // تحديث قائمة الزبون
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategory(CategoryModel category) async {
    isLoading.value = true;
    try {
      await _repo.updateCategory(category);
      Get.find<CategoryController>().fetchCategories(); // تحديث قائمة الزبون
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    // ملاحظة: الحذف الكامل للقسم يتطلب حذف كل المنتجات التابعة له أولاً
    // هذا منطق متقدم سنضيفه لاحقًا في الـ Repository
    await _repo.deleteCategory(categoryId);
    Get.find<CategoryController>().fetchCategories(); // تحديث قائمة الزبون
  }

  Future<String?> uploadCategoryImage(File file) async {
    isLoading.value = true;
    try {
      final url = await _storageRepo.uploadProductImage(file);
      return url;
    } finally {
      isLoading.value = false;
    }
  }

  /// ينسق عملية إنشاء أو تحديث قسم
  Future<void> saveCategory({
    required String name,
    CategoryModel? existingCategory,
  }) async {
    isLoading.value = true;
    try {
      String imageUrl;
      final imageFile = selectedImage.value; // ✅ نستخدم المتغير التفاعلي

      if (imageFile != null) {
        final uploadedUrl = await uploadCategoryImage(imageFile);
        if (uploadedUrl == null) throw Exception('فشل رفع الصورة.');
        imageUrl = uploadedUrl;
      } else if (existingCategory != null) {
        imageUrl = existingCategory.imageUrl;
      } else {
        throw Exception('يجب اختيار صورة للقسم الجديد.');
      }

      if (existingCategory != null) {
        final updatedCategory = existingCategory.copyWith(name: name, imageUrl: imageUrl);
        await updateCategory(updatedCategory);
      } else {
        final newCategory = CategoryModel(id: '', name: name, imageUrl: imageUrl);
        await addCategory(newCategory);
      }
    } finally {
      isLoading.value = false;
    }
  }
}

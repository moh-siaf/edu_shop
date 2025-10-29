// --- في ملف: lib/features/admin/categories/view/pages/add_category_page.dart ---

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../model/category_model.dart';
import '../viewmodel/manage_categories_controller.dart';

class AddCategoryPage extends StatelessWidget {
  const AddCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ManageCategoriesController>();
    final _formKey = GlobalKey<FormState>();

    final CategoryModel? existingCategory = Get.arguments as CategoryModel?;
    final bool isEdit = existingCategory != null;

    // استخدام TextEditingController بدون State
    final nameController = TextEditingController(text: existingCategory?.name ?? '');

    // التأكد من مسح الصورة القديمة عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearImage();
    });

    Future<void> submitForm() async {
      if (_formKey.currentState!.validate()) {
        if (controller.selectedImage.value == null && !isEdit) {
          Get.snackbar('خطأ', 'الرجاء اختيار صورة للقسم.');
          return;
        }

        try {
          await controller.saveCategory(
            name: nameController.text,
            existingCategory: existingCategory,
          );
          Get.back();
          Get.snackbar('نجاح', isEdit ? 'تم تعديل القسم بنجاح' : 'تم إضافة القسم بنجاح');
        } catch (e) {
          Get.snackbar('خطأ', 'حدث خطأ: ${e.toString()}');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل القسم' : 'إضافة قسم جديد'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم القسم'),
                validator: (value) => (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: AppSizes.sectionSpacing),
              Text('صورة القسم', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSizes.itemSpacing),
              GestureDetector(
                onTap: () => controller.pickImage(),
                child: Obx(() {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: _buildImagePreview(controller, isEdit, existingCategory),
                  );
                }),
              ),
              const SizedBox(height: AppSizes.sectionSpacing * 2),
              Obx(() {
                return ElevatedButton(
                  onPressed: controller.isLoading.value ? null : submitForm,
                  child: controller.isLoading.value
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(isEdit ? 'حفظ التعديلات' : 'إضافة القسم'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ManageCategoriesController controller, bool isEdit, CategoryModel? existingCategory) {
    if (controller.selectedImage.value != null) {
      return Image.file(controller.selectedImage.value!, fit: BoxFit.cover, width: double.infinity);
    } else if (isEdit && existingCategory!.imageUrl.isNotEmpty) {
      return CachedNetworkImage(imageUrl: existingCategory.imageUrl, fit: BoxFit.cover, width: double.infinity);
    } else {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, size: 50),
          SizedBox(height: 8),
          Text('انقر لاختيار صورة'),
        ],
      );
    }
  }
}

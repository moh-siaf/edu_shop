import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../../../model/category_model.dart';
import '../../../model/product_model.dart';
import '../../categories/viewmodel/category_controller.dart';
import '../../products/viewmodel/products_controller.dart';

class AddProductPage extends StatelessWidget {
  // 1. لا نمرر المنتج عبر الكونستركتر بعد الآن
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- 2. الكود الذكي لتحديد السياق ---
    final ProductModel? existingProduct = Get.arguments as ProductModel?;
    final bool isEdit = existingProduct != null;

    // --- 3. تعريف الكنترولرات والمتغيرات ---
    final controller = Get.find<ProductController>();
    final categoryCtrl = Get.find<CategoryController>();

    final nameCtrl = TextEditingController(text: existingProduct?.name ?? '');
    final priceCtrl = TextEditingController(text: existingProduct?.price.toString() ?? '');
    final descCtrl = TextEditingController(text: existingProduct?.description ?? '');

    final formKey = GlobalKey<FormState>();
    final Rx<File?> selectedImage = Rx<File?>(null);
    final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

    // --- 4. تحديد القيمة الأولية للقسم في وضع التعديل ---
    if (isEdit) {
      selectedCategory.value = categoryCtrl.getById(existingProduct!.categoryId);
    }

    Future<void> pickImage() async {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        selectedImage.value = File(picked.path);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل المنتج' : 'إضافة منتج جديد'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                // (واجهة الصورة وحقول النص تبقى كما هي)
                GestureDetector(
                  onTap: pickImage,
                  child: Obx(() {
                    final img = selectedImage.value;
                    final url = existingProduct?.imageUrl ?? '';
                    return Container(
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: img != null
                          ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(img, fit: BoxFit.cover))
                          : url.isNotEmpty
                          ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(url, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 48))))
                          : const Center(child: Text('اضغط لاختيار صورة 📸', style: TextStyle(color: Colors.grey))),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم المنتج', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'أدخل اسم المنتج' : null),
                const SizedBox(height: 12),
                TextFormField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'السعر', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'أدخل السعر' : null),
                const SizedBox(height: 12),
                TextFormField(controller: descCtrl, decoration: const InputDecoration(labelText: 'الوصف', border: OutlineInputBorder()), maxLines: 3),
                const SizedBox(height: 20),

                // القائمة المنسدلة للأقسام
                Obx(() {
                  return DropdownButtonFormField<CategoryModel>(
                    value: selectedCategory.value,
                    hint: const Text('اختر القسم'),
                    decoration: InputDecoration(border: const OutlineInputBorder(), labelText: 'القسم'),
                    items: categoryCtrl.categories.map((category) {
                      return DropdownMenuItem<CategoryModel>(value: category, child: Text(category.name));
                    }).toList(),
                    onChanged: (CategoryModel? newValue) {
                      selectedCategory.value = newValue;
                    },
                    validator: (value) => value == null ? 'يرجى اختيار قسم' : null,
                  );
                }),
                const SizedBox(height: 20),

                // زر الإضافة أو الحفظ
                ElevatedButton.icon(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    if (selectedCategory.value == null) {
                      Get.snackbar('خطأ', 'يجب اختيار قسم للمنتج.');
                      return;
                    }

                    controller.isLoading.value = true;
                    try {
                      String imageUrl = existingProduct?.imageUrl ?? '';
                      if (selectedImage.value != null) {
                        final uploaded = await controller.pickAndUploadImage(selectedImage.value!);
                        if (uploaded != null) imageUrl = uploaded;
                      }

                      final product = ProductModel(
                        id: existingProduct?.id ?? '',
                        name: nameCtrl.text.trim(),
                        price: double.tryParse(priceCtrl.text.trim()) ?? 0,
                        description: descCtrl.text.trim(),
                        imageUrl: imageUrl,
                        categoryId: selectedCategory.value!.id,
                      );

                      // --- ✅ الكود الجديد والمُحسن ✅ ---

                      try {
                        if (isEdit) {
                          await controller.updateProduct(product);
                          Get.back(); // العودة بعد النجاح
                          Get.snackbar('Success', 'Product updated successfully');
                        } else {
                          await controller.addProduct(product);
                          Get.back(); // العودة بعد النجاح
                          Get.snackbar('Success', 'Product added successfully');
                        }
                      } catch (e) {
                        // في حالة حدوث أي خطأ أثناء العملية
                        Get.snackbar('Error', 'An error occurred: ${e.toString()}');
                      }

                    } finally {
                      controller.isLoading.value = false;
                    }
                  },
                  icon: Icon(isEdit ? Icons.save : Icons.add),
                  label: Text(isEdit ? 'حفظ التعديلات' : 'إضافة المنتج'),
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12), textStyle: const TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

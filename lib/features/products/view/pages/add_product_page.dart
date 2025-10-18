import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/product_model.dart';
import '../../viewmodel/products_controller.dart';

class AddProductPage extends StatelessWidget {
  final ProductModel? existingProduct;
  const AddProductPage({super.key, this.existingProduct});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    final nameCtrl = TextEditingController(text: existingProduct?.name ?? '');
    final priceCtrl =
    TextEditingController(text: existingProduct?.price.toString() ?? '');
    final descCtrl =
    TextEditingController(text: existingProduct?.description ?? '');

    final formKey = GlobalKey<FormState>();
    final Rx<File?> selectedImage = Rx<File?>(null);

    Future<void> pickImage() async {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        selectedImage.value = File(picked.path);
      }
    }

    final bool isEdit = existingProduct != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'تعديل المنتج' : 'إضافة منتج جديد'),
        centerTitle: true,
      ),
      body: Obx(() {
        // ✅ مؤشر التحميل من الكنترولر فقط
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                // 🔹 الصورة
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
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(img, fit: BoxFit.cover),
                      )
                          : url.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                              child:
                              Icon(Icons.broken_image, size: 48)),
                        ),
                      )
                          : const Center(
                        child: Text('اضغط لاختيار صورة 📸',
                            style: TextStyle(color: Colors.grey)),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // 🔹 الاسم
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'اسم المنتج',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'أدخل اسم المنتج' : null,
                ),
                const SizedBox(height: 12),

                // 🔹 السعر
                TextFormField(
                  controller: priceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'السعر',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'أدخل السعر' : null,
                ),
                const SizedBox(height: 12),

                // 🔹 الوصف
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // 🔹 زر العملية
                ElevatedButton.icon(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    controller.isLoading.value = true;
                    try {
                      String imageUrl = existingProduct?.imageUrl ?? '';

                      // 🖼️ رفع الصورة إن وُجدت
                      if (selectedImage.value != null) {
                        final uploaded = await controller
                            .pickAndUploadImage(selectedImage.value!);
                        if (uploaded != null) imageUrl = uploaded;
                      }

                      // 🧱 بناء المنتج
                      final product = ProductModel(
                        id: existingProduct?.id ?? '',
                        name: nameCtrl.text.trim(),
                        price: double.tryParse(priceCtrl.text.trim()) ?? 0,
                        description: descCtrl.text.trim(),
                        imageUrl: imageUrl,
                      );

                      // ⚙️ استدعاء دوال الكنترولر الجاهزة
                      if (isEdit) {
                        await controller.updateProduct(product);
                      } else {
                        await controller.addProduct(product);
                      }

                      Get.back(); // الرجوع بعد التنفيذ
                    } catch (e) {
                      Get.snackbar('خطأ', 'حدث خطأ أثناء العملية: $e');
                    } finally {
                      controller.isLoading.value = false;
                    }
                  },
                  icon: Icon(isEdit ? Icons.save : Icons.add),
                  label: Text(isEdit ? 'حفظ التعديلات' : 'إضافة المنتج'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

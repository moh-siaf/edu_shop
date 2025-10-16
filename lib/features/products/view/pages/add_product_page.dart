import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/product_model.dart';
import '../../viewmodel/products_controller.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _controller = Get.find<ProductController>(); // 🔹 نربط الكنترولر
  final _formKey = GlobalKey<FormState>();

  // 📝 حقول الإدخال
  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  File? _selectedImage; // لحفظ الصورة المختارة

  // 🔹 اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  // 🔹 إضافة المنتج (رفع الصورة + إدخال البيانات)
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // 🔸 حالة تحميل بسيطة
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _controller.pickAndUploadImage(_selectedImage!);
    }

    // 🔸 إنشاء المنتج
    final product = ProductModel(
      id: '', // Firebase يولّد تلقائي
      name: nameCtrl.text.trim(),
      price: double.tryParse(priceCtrl.text.trim()) ?? 0,
      description: descCtrl.text.trim(),
      imageUrl: imageUrl ?? '',
    );

    // 🔸 إضافة المنتج
    await _controller.addProduct(product);

    // 🔸 إغلاق التحميل والرجوع
    Get.back(); // يغلق الديالوج
    Get.back(); // يرجع للصفحة الرئيسية
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔹 صورة المنتج
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage == null
                      ? const Center(child: Text('اضغط لاختيار صورة 📸'))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 حقل الاسم
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'اسم المنتج'),
                validator: (v) => v!.isEmpty ? 'أدخل اسم المنتج' : null,
              ),
              const SizedBox(height: 10),

              // 🔹 حقل السعر
              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'السعر'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'أدخل السعر' : null,
              ),
              const SizedBox(height: 10),

              // 🔹 حقل الوصف
              TextFormField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'الوصف'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // 🔹 زر الإضافة
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add),
                label: const Text('إضافة المنتج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

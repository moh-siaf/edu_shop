

/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../viewmodel/category_controller.dart';

class AddCategoryPage extends StatelessWidget {
  AddCategoryPage({super.key});

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<CategoryController>();
  final _selectedImage = Rx<File?>(null);

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage.value = File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قسم جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- اختيار الصورة ---
              GestureDetector(
                onTap: _pickImage,
                child: Obx(() {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedImage.value != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_selectedImage.value!, fit: BoxFit.cover),
                    )
                        : const Center(child: Icon(Icons.camera_alt, size: 50, color: Colors.grey)),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // --- حقل الاسم ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم القسم', border: OutlineInputBorder()),
                validator: (v) => v!.trim().isEmpty ? 'حقل الاسم مطلوب' : null,
              ),
              const SizedBox(height: 32),

              // --- زر الحفظ ---
              Obx(() {
                return _controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: () {
                    if (!_formKey.currentState!.validate() || _selectedImage.value == null) {
                      Get.snackbar('بيانات ناقصة', 'الرجاء إدخال الاسم واختيار صورة.');
                      return;
                    }
                    // --- استدعاء واحد فقط ---
                   _controller.createCategory(
                      name: _nameController.text.trim(),
                      imageFile: _selectedImage.value!,
                    );
                  },
                  child: const Text('حفظ القسم'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}*/

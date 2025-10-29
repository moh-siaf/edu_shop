// --- في ملف: lib/features/admin/view/pages/upsert_offer_page.dart ---
// (النسخة التي تستخدم الويدجت الأساسية)


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';

import '../../../offers/model/offer_model.dart';
import '../../viewmodel/manage_offers_controller.dart';

class UpsertOfferPage extends StatelessWidget {
  const UpsertOfferPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ManageOffersController ctrl = Get.find<ManageOffersController>();
    final OfferModel? existingOffer = Get.arguments as OfferModel?;
    final isEditMode = (existingOffer != null);

    ctrl.initForUpsert(existingOffer);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'تعديل العرض' : 'إضافة عرض جديد'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Form(
          key: ctrl.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- قسم الصورة (لم يتغير) ---
              Obx(() {
                final selectedImageFile = ctrl.selectedImage.value;
                return Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                          border: Border.all(color: theme.colorScheme.outline),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                          child: selectedImageFile != null
                              ? Image.file(selectedImageFile, fit: BoxFit.cover)
                              : (isEditMode && existingOffer!.imageUrl.isNotEmpty)
                              ? CachedNetworkImage(imageUrl: existingOffer!.imageUrl, fit: BoxFit.cover)
                              : const Icon(Icons.image_outlined, size: 50),
                        ),
                      ),
                      FloatingActionButton.small(
                        onPressed: ctrl.pickImage,
                        child: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSizes.spaceLarge),

              // ✅ [مُعدل]: استخدام TextFormField مباشرة
              TextFormField(
                controller: ctrl.titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان العرض',
                  hintText: 'مثال: خصم الصيف',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: AppSizes.spaceMedium),

              // ✅ [مُعدل]: استخدام TextFormField مباشرة
              TextFormField(
                controller: ctrl.descriptionController,
                decoration: const InputDecoration(
                  labelText: 'وصف العرض',
                  hintText: 'مثال: خصومات تصل إلى 30% على الإلكترونيات',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty) ? 'هذا الحقل مطلوب' : null,
              ),
              const SizedBox(height: AppSizes.spaceLarge * 2),

              // ✅ [مُعدل]: استخدام ElevatedButton مباشرة
              Obx(() {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: ctrl.isLoading.value ? null : () => _save(ctrl, existingOffer),
                  child: ctrl.isLoading.value
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('حفظ'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _save(ManageOffersController ctrl, OfferModel? existingOffer) async {
    if (!ctrl.formKey.currentState!.validate()) {
      return;
    }

    final success = await ctrl.saveOffer(
      title: ctrl.titleController.text,
      description: ctrl.descriptionController.text,
      existingOffer: existingOffer,
    );

    if (success) {
      Get.back();
    }
  }
}

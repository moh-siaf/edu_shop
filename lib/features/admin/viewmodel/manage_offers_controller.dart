// --- في ملف: lib/features/admin/viewmodel/manage_offers_controller.dart ---

import 'dart:io';

import '../../../data/repositories/offer_repository.dart';
import '../../../data/repositories/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../../offers/model/offer_model.dart';
import '../../offers/viewmodel/offers_controller.dart';

class ManageOffersController extends GetxController {
  // --- 1. إنشاء مباشر للـ Repositories ---
  final OfferRepository _offerRepo = OfferRepository();
  final StorageRepository _storageRepo = StorageRepository();

  // --- 2. متغيرات الحالة ---
  final isLoading = false.obs;
  final selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final offers = <OfferModel>[].obs;

  // ✅ [جديد]: متغيرات الفورم
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  // --- 3. التهيئة والتنظيف ---

  /// ✅ [جديد]: دالة لتهيئة الكنترولر بالبيانات عند فتح صفحة الإضافة/التعديل
  void initForUpsert(OfferModel? offer) {
    titleController = TextEditingController(text: offer?.title ?? '');
    descriptionController = TextEditingController(text: offer?.description ?? '');
    clearImage(); // تنظيف أي صورة سابقة تم اختيارها
  }

  /// ✅ [جديد]: التخلص من الـ controllers عند إغلاق الصفحة لتجنب تسريب الذاكرة
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchOffers() async {
    try {
      isLoading.value = true;
      final offersList = await _offerRepo.getAllOffers();
      offers.assignAll(offersList);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل جلب قائمة العروض: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 4. دوال إدارة الصورة ---
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void clearImage() {
    selectedImage.value = null;
  }

  // --- 5. دوال التفاعل مع قاعدة البيانات ---

  /// ينسق عملية إنشاء أو تحديث عرض
  Future<bool> saveOffer({
    required String title,
    required String description,
    OfferModel? existingOffer,
  }) async {
    isLoading.value = true;
    try {
      String imageUrl;
      final imageFile = selectedImage.value;

      if (imageFile != null) {
        final uploadedUrl = await _storageRepo.uploadProductImage(imageFile);
        if (uploadedUrl == null) throw Exception('فشل رفع الصورة.');
        imageUrl = uploadedUrl;
      } else if (existingOffer != null) {
        imageUrl = existingOffer.imageUrl;
      } else {
        throw Exception('الرجاء اختيار صورة للعرض.');
      }

      final offer = (existingOffer ?? const OfferModel.empty()).copyWith(
        title: title,
        description: description,
        imageUrl: imageUrl,
      );

      if (existingOffer != null) {
        await _offerRepo.updateOffer(offer);
      } else {
        await _offerRepo.addOffer(offer);
      }

      Get.find<ManageOffersController>().fetchOffers();
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('فشل', e.toString());
      return false;
    }
  }


  /// حذف عرض
  Future<void> deleteOffer(String offerId) async {
    try {
      await _offerRepo.deleteOffer(offerId);
      Get.find<ManageOffersController>().fetchOffers();
    } catch (e) {
      Get.snackbar('فشل الحذف', e.toString());
    }
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../routes/app_routes.dart';
import '../../../offers/model/offer_model.dart';
import '../../viewmodel/manage_offers_controller.dart';


class ManageOffersPage extends StatelessWidget {
  const ManageOffersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // بما أننا استخدمنا Binding، يمكننا الآن استخدام Get.find بأمان
    final ManageOffersController ctrl = Get.find<ManageOffersController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة العروض والإعلانات'),
        centerTitle: true,
      ),
      // --- 1. زر عائم لإضافة عرض جديد ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // الانتقال لصفحة الإضافة بدون تمرير أي بيانات
          Get.toNamed(Routes.upsertOffer);
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        // --- 2. عرض مؤشر تحميل ---
        if (ctrl.isLoading.value && ctrl.offers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        // --- 3. عرض رسالة في حالة عدم وجود عروض ---
        if (ctrl.offers.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد عروض أو إعلانات حاليًا.\nاضغط على زر (+) للبدء.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        // --- 4. عرض قائمة العروض ---
        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          itemCount: ctrl.offers.length,
          itemBuilder: (context, index) {
            final OfferModel offer = ctrl.offers[index];
            return Card(
              margin: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.cardPadding),
                child: Row(
                  children: [
                    // --- صورة العرض ---
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      child: CachedNetworkImage(
                        imageUrl: offer.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceMedium),
                    // --- عنوان ووصف العرض ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offer.title, style: theme.textTheme.titleMedium),
                          const SizedBox(height: AppSizes.spaceSmall),
                          Text(
                            offer.description,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // --- أزرار التعديل والحذف ---
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () {
                            // الانتقال لصفحة التعديل مع تمرير بيانات العرض الحالي
                            Get.toNamed(Routes.upsertOffer, arguments: offer);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                          onPressed: () => _showDeleteConfirmation(context, ctrl, offer),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // --- دالة لعرض حوار تأكيد الحذف ---
  void _showDeleteConfirmation(BuildContext context, ManageOffersController ctrl, OfferModel offer) {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد من رغبتك في حذف "${offer.title}"؟ لا يمكن التراجع عن هذا الإجراء.',
      textConfirm: 'حذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // إغلاق الحوار أولاً
        ctrl.deleteOffer(offer.id); // تنفيذ الحذف
      },
    );
  }
}

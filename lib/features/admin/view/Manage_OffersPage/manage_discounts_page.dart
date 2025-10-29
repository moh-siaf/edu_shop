// --- في ملف: lib/features/admin/view/pages/manage_discounts_page.dart ---

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../model/product_model.dart';
import '../../../../routes/app_routes.dart';
import '../../../offers/viewmodel/offers_controller.dart';
import '../../viewmodel/manage_discounts_controller.dart';

class ManageDiscountsPage extends StatelessWidget {
  const ManageDiscountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ✅ 1. الوصول إلى الكنترولر الذي تم إنشاؤه بواسطة الـ Binding
    final ManageDiscountsController ctrl = Get.find<ManageDiscountsController>();
    final OffersController _offersController = Get.find<OffersController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الخصومات'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ✅ [مُعدل]: ننتقل مع تمرير "العلامة" كـ argument
          Get.toNamed(
            Routes.manageCategories,
            arguments: {'isSelectingForDiscount': true},
          );
        },
        child: const Icon(Icons.add),

      ),
      // ✅ 2. استخدام Obx للاستماع للتغييرات في قائمة المنتجات المخفضة
      body: Obx(() {
        final discountedProducts = ctrl.discountedProducts;

        // --- عرض رسالة في حالة عدم وجود خصومات ---
        if (discountedProducts.isEmpty) {
          return const Center(
            child: Text(
              'لا توجد منتجات عليها خصم حاليًا.\nاضغط على زر (+) لإضافة خصم جديد.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // --- عرض قائمة المنتجات المخفضة ---
        return ListView.builder(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          itemCount: discountedProducts.length,
          itemBuilder: (context, index) {
            final ProductModel product = discountedProducts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: AppSizes.spaceMedium),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.cardPadding),
                child: Row(
                  children: [
                    // --- صورة المنتج ---
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spaceMedium),
                    // --- اسم المنتج والأسعار ---
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: theme.textTheme.titleMedium),
                          const SizedBox(height: AppSizes.spaceSmall),
                          // --- عرض السعر الأصلي (مشطوب) ---
                          Text(
                            '${product.price.toStringAsFixed(2)} ر.س',
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          // --- عرض السعر بعد الخصم ---
                          Text(
                            '${product.discountPrice?.toStringAsFixed(2)} ر.س (-${product.discountPercentage}%)',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // --- زر لإزالة الخصم ---
                    Obx(() {
                      return IconButton(
                        icon: ctrl.isUpdating.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : Icon(Icons.delete_outline, color: theme.colorScheme.error),
                        onPressed: () => _showDeleteConfirmation(context, ctrl, product),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // --- دالة لعرض حوار تأكيد إزالة الخصم ---
  void _showDeleteConfirmation(BuildContext context, ManageDiscountsController ctrl, ProductModel product) {
    Get.defaultDialog(
      title: 'تأكيد الإزالة',
      middleText: 'هل أنت متأكد من رغبتك في إزالة الخصم من منتج "${product.name}"؟',
      textConfirm: 'إزالة الخصم',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        ctrl.removeProductDiscount(product.id);// تنفيذ إزالة الخصم
      },
    );
  }
}

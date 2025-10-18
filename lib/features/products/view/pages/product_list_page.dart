import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

import '../../../../routes/app_routes.dart';
import '../../viewmodel/products_controller.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('قائمة المنتجات'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return const Center(
            child: Text('لا توجد منتجات حالياً', style: AppTextStyles.body),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return GestureDetector(
              onTap: () {
                // 👇 انتقال إلى صفحة التفاصيل
                Get.toNamed(Routes.productDetails, arguments: product);
              },
              child: Hero(
                tag: 'product_${product.id}',
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼️ صورة المنتج
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        child: product.imageUrl.isEmpty
                            ? Container(
                          height: 110,
                          width: 110,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, size: 40),
                        )
                            : Image.network(
                          product.imageUrl,
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 110,
                            width: 110,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // 🔹 معلومات المنتج
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name,
                                  style: AppTextStyles.subheading.copyWith(color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price.toStringAsFixed(2)} ر.س',
                                style: AppTextStyles.subheading.copyWith(color: AppColors.success),
                              ),
                              const SizedBox(height: 6),

                            ],
                          ),
                        ),
                      ),

                      // ⚙️ زر الخيارات (تعديل / حذف)
                      Padding(
                        padding: const EdgeInsets.only(right: 6, top: 6),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              Get.toNamed(
                                Routes.addProduct,
                                arguments: product,
                              );
                            } else if (value == 'delete') {
                              Get.defaultDialog(
                                title: 'تأكيد الحذف',
                                middleText: 'هل تريد حذف هذا المنتج؟',
                                textConfirm: 'حذف',
                                textCancel: 'إلغاء',
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  Get.back();
                                  controller.deleteProduct(product.id);
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: AppColors.primary),
                                  SizedBox(width: 8),
                                  Text('تعديل المنتج'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline, color: AppColors.error),
                                  SizedBox(width: 8),
                                  Text('حذف المنتج'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.addProduct),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

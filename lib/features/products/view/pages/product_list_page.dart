import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

import '../../../../model/category_model.dart';
import '../../../../model/product_model.dart';
import '../../../../routes/app_routes.dart';
import '../../viewmodel/products_controller.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final CategoryModel? category = Get.arguments as CategoryModel?;
    final bool isFiltered = category != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Get.toNamed(Routes.cart),
          ),
        ],
        title: Text(isFiltered ? category.name : 'قائمة المنتجات'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<ProductModel> displayProducts;
        if (isFiltered) {
          displayProducts = controller.products.where((p) => p.categoryId == category.id).toList();
        } else {
          displayProducts = controller.products;
        }

        if (displayProducts.isEmpty) {
          return Center(
            child: Text(
              isFiltered ? 'لا توجد منتجات في هذا القسم حاليًا' : 'لا توجد منتجات حالياً',
              style: AppTextStyles.body,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: displayProducts.length,
          itemBuilder: (context, index) {
            final product = displayProducts[index];

            return GestureDetector(
              onTap: () {
                // الانتقال إلى صفحة التفاصيل (لا تغيير هنا)
                Get.toNamed(Routes.productDetails, arguments: product);
              },
              child: Hero(
                // إصلاح مشكلة الـ Hero tag
                tag: 'product_list_${product.id}',
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.name, style: AppTextStyles.subheading.copyWith(color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price.toStringAsFixed(2)} ر.س',
                                style: AppTextStyles.subheading.copyWith(color: AppColors.success),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 6, top: 6),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onSelected: (value) {
                            // --- ✅ الإصلاح الرئيسي هنا ---
                            if (value == 'edit') {
                              // أعدنا تفعيل الانتقال إلى صفحة الإضافة مع إرسال المنتج
                              Get.toNamed(Routes.addProduct, arguments: product);
                            }
                            // -----------------------------
                            else if (value == 'delete') {
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
                            const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, color: AppColors.primary), SizedBox(width: 8), Text('تعديل المنتج')])),
                            const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, color: AppColors.error), SizedBox(width: 8), Text('حذف المنتج')])),
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
      floatingActionButton: isFiltered
          ? null
          : FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.addProduct),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
